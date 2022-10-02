import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        RegisterGeneratedPlugins(registry: flutterViewController)

        // setup method channel, on macOS, binaryMessener is from engine, this is different from iOS
        let channel = FlutterMethodChannel(name: "AnimeGo", binaryMessenger: flutterViewController.engine.binaryMessenger)
        channel.setMethodCallHandler { call, result in
            print("call.method: \(call.method), call.arguments: \(call.arguments ?? "nothing")")

            switch call.method {
            case "webview_player":
                guard let link = call.arguments as? String else {
                    result(nil)
                    assertionFailure("The link string is not passed in")
                    return
                }

                self.launchWebView(link, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        super.awakeFromNib()
    }

    private func launchWebView(_ link: String, result: @escaping FlutterResult) {
        // get webview_rust path from resources
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "webview_rust", ofType: nil) else {
            result(nil)
            assertionFailure("webview_rust is not found, make sure you build it with cargo build --release in the webview folder")
            return
        }
        print("webview_rust path: \(path)")

        // run it with link
        let task = Process()
        task.launchPath = path
        task.arguments = [link]
        print("link: \(link)")

        // run it and get return code
        task.launch()
        task.waitUntilExit()
        let returnCode = task.terminationStatus
        print("code: \(returnCode)")
        result(returnCode == 0)
    }
}
