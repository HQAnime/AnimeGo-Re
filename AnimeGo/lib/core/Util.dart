import 'package:flutter/material.dart';

class Util {
  final BuildContext context;
  Util(this.context);

  bool isDarkMode() {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}