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
            launchUrlString(
              Uri(
                scheme: 'https',
                host: 'www.google.com',
                path: '/search',
                queryParameters: {'q': name},
              ).toString(),
            );
            FirebaseEventService().logUseGoogle();
          },
          child: const Text(
            'Google',
          ),
        ),
        // AnimeFlatButton(
        //   onPressed: () {
        //     launchUrlString(
        //       Uri(
        //         scheme: 'https',
        //         host: 'www.duckduckgo.com',
        //         path: '/',
        //         queryParameters: {'q': name},
        //       ).toString(),
        //     );
        //     FirebaseEventService().logUseGoogle();
        //   },
        //   child: const Text('DuckDuckGo'),
        // ),
        AnimeFlatButton(
          onPressed: () {
            launchUrlString(
              Uri(
                scheme: 'https',
                host: 'myanimelist.net',
                path: '/search/all',
                queryParameters: {'q': name},
              ).toString(),
            );
            FirebaseEventService().logUseMAL();
          },
          child: const Text('MAL'),
        ),
      ],
    );
  }
}
