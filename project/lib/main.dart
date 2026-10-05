import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/page/HomeShell.dart';
import 'package:animego/ui/page/TabletHomePage.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Draw behind the status and navigation bars (Android 15+ / Material You).
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (Util.isMobile()) {
    await Firebase.initializeApp();
  }
  await SourceManager().init();
  runApp(const MyApp());
}

// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// Used when the platform has no Material You colour palette (e.g. iOS).
  static final _fallbackLight =
      ColorScheme.fromSeed(seedColor: Colors.deepOrange);
  static final _fallbackDark = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'AnimeGo Re',
        theme: _theme(lightDynamic ?? _fallbackLight),
        darkTheme: _theme(darkDynamic ?? _fallbackDark),
        builder: (context, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          // Transparent bars so the content flows edge to edge.
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              systemNavigationBarContrastEnforced: false,
            ),
          );
          return child ?? const SizedBox.shrink();
        },
        home: const _Root(),
      ),
    );
  }

  ThemeData _theme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }
}

/// Loads local data before showing the home.
class _Root extends StatelessWidget {
  const _Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global().init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // Check for update after init has been done
          Global().checkForUpdate(context);
          // Use another view for tablets (or devices with a large screen)
          if (Util(context).isTablet()) return TabletHomePage();
          return HomeShell();
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
