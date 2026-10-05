import 'package:flutter/material.dart';

/// A [ListTile] whose title and subtitle are both centered.
class CenteredListTile extends StatelessWidget {
  const CenteredListTile({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        subtitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
