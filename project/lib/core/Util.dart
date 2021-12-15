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
    var size = MediaQuery.of(context).size;
    var diagonal = sqrt(
      (size.width * size.width) + (size.height * size.height),
    );

    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  Size screenSize() {
    return MediaQuery.of(context).size;
  }
}
