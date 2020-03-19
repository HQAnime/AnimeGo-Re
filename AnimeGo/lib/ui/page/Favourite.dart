import 'package:flutter/material.dart';

/// Favourite class
class Favourite extends StatelessWidget {
  final bool showAppBar;
  Favourite({Key key, this.showAppBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: Text('Settings')
      ) : null,
      body: Center(
        child: Text('Coming soon...'),
      ),
    );
  }
}
