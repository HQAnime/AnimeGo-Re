import 'dart:io';

import 'package:flutter/material.dart';

class Util {
  final BuildContext context;
  Util(this.context);

  bool isDarkMode() {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  static bool isMobile() {
    if (identical(0, 0.0)) return false;
    return Platform.isIOS || Platform.isAndroid;
  }
}