import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// SearchAnimeButton class
class SearchAnimeButton extends StatelessWidget {
  const SearchAnimeButton({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimeFlatButton(
          onPressed: () {
            launch('https://www.google.com/search?q=$name');
          },
          child: Text(
            'Google',
          ),
        ),
        AnimeFlatButton(
          onPressed: () {
            launch('https://duckduckgo.com/?q=$name');
          },
          child: Text('DuckDuckGo'),
        ),
      ],
    );
  }
}
