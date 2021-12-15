# How to compile
- Setup [flutter](https://flutter.dev/docs/get-started/install)
- Run `flutter run` to install on your device

# Firebase
It is important to enable debug mode. This way, all events are sent immediately.
~~~
adb shell setprop debug.firebase.analytics.app com.yihengquan.gogoanime
~~~
~~~
adb shell setprop debug.firebase.analytics.app .none.
~~~

# Desktop
## Linux
Follow [this guide](https://docs.flutter.dev/desktop#additional-linux-requirements) to setup the environment. VLC is also required for dart_vlc.

```
sudo apt-get install vlc libvlc-dev clang cmake ninja-build pkg-config libgtk-3-dev
```

NOTE: `DON'T install Flutter with snap`. Download the package or use git instead. It seems that `cmake` path is set to 3.10.2 no matter what and this breaks things.
