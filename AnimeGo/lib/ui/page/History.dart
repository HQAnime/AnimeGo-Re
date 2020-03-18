import 'package:flutter/material.dart';

/// History class
class History extends StatelessWidget {
  final bool showAppBar;
  History({Key key, this.showAppBar = true}) : super(key: key);

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
