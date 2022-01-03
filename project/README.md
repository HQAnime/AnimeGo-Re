# How to compile
- Setup [flutter](https://flutter.dev/docs/get-started/install)
- Run `flutter run` to install on your device

Currently running on Flutter 2.8.1 and Dart 2.15.1.

# Firebase
It is important to enable debug mode. This way, all events are sent immediately.
~~~
adb shell setprop debug.firebase.analytics.app com.yihengquan.gogoanime
~~~
~~~
adb shell setprop debug.firebase.analytics.app .none.
~~~

# Desktop
~~VLC is used for desktop. It requires http-referrer and adaptive-use-access to be set correctly. The player has to be paused once before the video is showing correctly.~~ The VLC program is now needed to be installed or the default browser will be used. 

## Linux
Follow [this guide](https://docs.flutter.dev/desktop#additional-linux-requirements) to setup the environment. VLC is also required for dart_vlc.

```
sudo apt-get install vlc clang cmake ninja-build pkg-config libgtk-3-dev
```

NOTE: `DON'T install Flutter with snap`. Download the package or use git instead. It seems that `cmake` path is set to 3.10.2 no matter what and this breaks things.

## Windows
Visual Studio 2019 is required, [guide](https://docs.flutter.dev/desktop#additional-windows-requirements).

## Mac OS
Xcode is required (13 or 12), [guide](https://docs.flutter.dev/desktop#additional-macos-requirements).
