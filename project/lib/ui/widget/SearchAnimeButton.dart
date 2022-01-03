import 'package:animego/core/Firebase.dart';
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
            launch(
              Uri(
                scheme: 'https',
                host: 'www.google.com',
                path: '/search',
                queryParameters: {'q': name},
              ).toString(),
            );
            FirebaseEventService().logUseGoogle();
          },
          child: Text(
            'Google',
          ),
        ),
        AnimeFlatButton(
          onPressed: () {
            launch(
              Uri(
                scheme: 'https',
                host: 'www.duckduckgo.com',
                path: '/',
                queryParameters: {'q': name},
              ).toString(),
            );
            FirebaseEventService().logUseGoogle();
          },
          child: Text('DuckDuckGo'),
        ),
      ],
    );
  }
}
