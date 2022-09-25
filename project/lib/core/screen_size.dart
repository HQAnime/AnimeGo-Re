import 'package:flutter/material.dart';

class ScreenSize {
  ScreenSize._(this._context);
  final BuildContext _context;

  static of(BuildContext context) => ScreenSize._(context);

  MediaQueryData get mediaQuery => MediaQuery.of(_context);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get scaledWidth => width / mediaQuery.devicePixelRatio;

  bool get isCompact => scaledWidth < 600;
  bool get isMedium => scaledWidth >= 600 && scaledWidth < 840;
  bool get isExpanded => scaledWidth >= 840;
}
