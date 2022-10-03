#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"

// headers for method channel
// https://stackoverflow.com/a/69821423
#include <flutter/binary_messenger.h>
#include <flutter/method_channel.h>
#include <flutter/method_result_functions.h>
#include <flutter/standard_method_codec.h>

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

void launchWebView(const flutter::MethodCall<>&,
                   std::unique_ptr<flutter::MethodResult<>>);
void setupMethodChannel(flutter::BinaryMessenger* messenger) {
    const std::string channelName = "AnimeGo";
    const auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            messenger, channelName,
            &flutter::StandardMethodCodec::GetInstance());

    channel->SetMethodCallHandler([](const auto& call, auto result) {
        if (call.method_name().compare("webview_player") == 0) {
            launchWebView(call, std::move(result));
        } else {
            result->NotImplemented();
        }
    });
}

bool FlutterWindow::OnCreate() {
    if (!Win32Window::OnCreate()) {
        return false;
    }

    RECT frame = GetClientArea();

    // The size here must match the window dimensions to avoid unnecessary
    // surface creation / destruction in the startup path.
    flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
        frame.right - frame.left, frame.bottom - frame.top, project_);
    // Ensure that basic setup of the controller was successful.
    if (!flutter_controller_->engine() || !flutter_controller_->view()) {
        return false;
    }
    RegisterPlugins(flutter_controller_->engine());
    SetChildContent(flutter_controller_->view()->GetNativeWindow());
    // similar to macOS the messenger is coming from the engine
    setupMethodChannel(flutter_controller_->engine()->messenger());
    return true;
}

void FlutterWindow::OnDestroy() {
    if (flutter_controller_) {
        flutter_controller_ = nullptr;
    }

    Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd,
                              UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
    // Give Flutter, including plugins, an opportunity to handle window
    // messages.
    if (flutter_controller_) {
        std::optional<LRESULT> result =
            flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                          lparam);
        if (result) {
            return *result;
        }
    }

    switch (message) {
        case WM_FONTCHANGE:
            flutter_controller_->engine()->ReloadSystemFonts();
            break;
    }

    return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

// Callbacks from Flutter
void launchWebView(const flutter::MethodCall<>& call,
                   std::unique_ptr<flutter::MethodResult<>> result) {
    // errors are not handled here so pass result->Success(); back to Flutter
    try {
        auto argument = call.arguments();
        if (argument->IsNull()) {
            result->Success();
            return;
        }

        // get the exe running path
        char path[MAX_PATH];
        GetCurrentDirectoryA(MAX_PATH, path);
        // get the directory of the exe
        std::string exePath = std::string(path);
        std::string exeDir = exePath.substr(0, exePath.find_last_of("\\/"));

        std::string url = std::get<std::string>(*argument);
        // run it with the webview_rust.exe which is under the same directory
        std::string command = "\"" + exeDir + "\\webview_rust.exe\" " + url;
        std::cout << command << std::endl;
        int returnCode = system(command.c_str());
        result->Success(flutter::EncodableValue(returnCode == 0));
    } catch (const std::exception&) {
        result->Success();
    }
}
