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
