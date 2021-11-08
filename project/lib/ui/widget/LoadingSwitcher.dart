import 'package:animego/core/Util.dart';
import 'package:flutter/material.dart';

/// LoadingSwitcher class
class LoadingSwitcher extends StatefulWidget {
  const LoadingSwitcher({
    Key? key,
    required this.loading,
    required this.child,
    this.repeat,
  }) : super(key: key);

  final Widget child;
  final bool loading;
  final bool? repeat;

  @override
  _LoadingSwitcherState createState() => _LoadingSwitcherState();
}

class _LoadingSwitcherState extends State<LoadingSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  final bool showAnimation = Util.isMobile();

  @override
  void initState() {
    super.initState();
    if (showAnimation) {
      this.controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
        value: 0.0,
      );
      this.scale = CurvedAnimation(
        parent: this.controller,
        curve: Curves.linearToEaseOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return widget.child;
    } else if (showAnimation) {
      if (widget.repeat == true) controller.reset();
      controller.forward();
      return ScaleTransition(
        scale: this.scale,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
