import 'package:flutter/material.dart';

/// LoadingSwitcher class
class LoadingSwitcher extends StatefulWidget {
  final Widget child;
  final bool loading;
  LoadingSwitcher({Key key, @required this.loading, @required this.child}) : super(key: key);

  @override
  _LoadingSwitcherState createState() => _LoadingSwitcherState();
}


class _LoadingSwitcherState extends State<LoadingSwitcher> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scale;

  @override
  void initState() {
    super.initState();
    this.controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this, value: 0.0);
    this.scale = CurvedAnimation(parent: this.controller, curve: Curves.linearToEaseOut);
  }

  @override
  void setState(fn) {
    this.controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return widget.child;
    } else {
      // Show the animation
      controller.reset();
      controller.forward();
      return ScaleTransition(
        scale: this.scale,
        child: widget.child,
      );
    }
  }
}
