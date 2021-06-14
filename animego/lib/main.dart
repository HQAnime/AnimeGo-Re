import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/ui/page/LastestAnime.dart';
import 'package:animego/ui/page/TabletHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// This widget is the root of the application.
class MyApp extends StatelessWidget {
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    accentColor: Colors.orange,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    ),
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeGo Re',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: FutureBuilder(
        future: Global().init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final window = WidgetsBinding.instance?.window;
          // This listens to platform change
          window?.onPlatformBrightnessChanged = () {
            final useDark = window.platformBrightness == Brightness.dark;
            // Setup navigation bar colour
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor:
                    useDark ? Colors.grey[900] : Colors.grey[50],
                systemNavigationBarIconBrightness:
                    useDark ? Brightness.light : Brightness.dark,
              ),
            );
          };

          // The data is simply a `true`
          if (snapshot.hasData) {
            // Check for update after init has been done
            Global().checkForUpdate(context);
            // Use another view for tablets (or devices with a large screen)
            if (Util(context).isTablet()) return TabletHomePage();
            return LastestAnime();
          } else {
            // A simple loading screen so that it is not that boring
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading...'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
