import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/ui/page/LastestAnime.dart';
import 'package:animego/ui/page/adaptive_home.dart';
import 'package:animego/ui/page/tablet/TabletHomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setup logger and make sure it only prints in debug mode
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      final message = '${record.loggerName}: ${record.message}';
      print('${record.level.name}|$message');
    }
  });

  if (Util.isMobile()) {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// This widget is the root of the application.
class MyApp extends StatelessWidget {
  final lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    useMaterial3: true,
  );

  // TODO: find a better solution, this is too manual
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Colors.orange),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.orange,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: Colors.orange,
    ),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeGo Re',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: FutureBuilder(
        future: Global().init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final window = WidgetsBinding.instance.window;
          // This listens to platform change
          window.onPlatformBrightnessChanged = () {
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

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildHome(context, snapshot),
            // scale in from a circle
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    );
  }

  Widget _buildHome(BuildContext context, AsyncSnapshot snapshot) {
    // The data is simply a `true`
    if (snapshot.hasData) {
      // Check for update after init has been done
      Global().checkForUpdate(context);

      // TODO: try out the new adaptive widget
      return AdaptiveHomePage();

      // Use another view for tablets (or devices with a large screen)
      if (Util(context).isTablet()) return const TabletHomePage();
      return const LastestAnime();
    } else {
      // A simple loading screen so that it is not that boring
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
