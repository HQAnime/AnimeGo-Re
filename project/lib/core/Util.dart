import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Util {
  final BuildContext context;
  Util(this.context);

  bool isDarkMode() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static bool isMobile() {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isAndroid;
  }

  static bool isDesktop() {
    if (kIsWeb) return true;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  static bool isIOS() {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  static bool isAndroid() {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static bool isWeb() => kIsWeb;

  /// From https://stackoverflow.com/a/53912090
  bool isTablet() {
    // Desktop is always true
    if (isDesktop()) return true;

    // This is for iPhone, iPad and Android phones & tablets
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final diagonal = sqrt(width * width + height * height);

    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  Size screenSize() {
    return MediaQuery.of(context).size;
  }

  static PageRoute platformPageRoute({
    required Widget Function(BuildContext context) builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    if (isMobile()) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      );
    } else {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return builder(context);
        },
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    }
  }
}
