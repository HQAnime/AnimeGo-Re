import 'package:animego/core/Firebase.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            launchUrlString('https://www.google.com/search?q=$name');
            FirebaseEventService().logUseGoogle();
          },
          child: Text(
            'Google',
          ),
        ),
        AnimeFlatButton(
          onPressed: () {
            launchUrlString('https://duckduckgo.com/?q=$name');
            FirebaseEventService().logUseGoogle();
          },
          child: Text('DuckDuckGo'),
        ),
      ],
    );
  }
}
