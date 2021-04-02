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
        FlatButton(
            onPressed: () {
              launch('https://www.google.com/search?q=$name');
            },
            child: Text(
              'Google',
            )),
        FlatButton(
          onPressed: () {
            launch('https://duckduckgo.com/?q=$name');
          },
          child: Text('DuckDuckGo'),
        ),
      ],
    );
  }
}
