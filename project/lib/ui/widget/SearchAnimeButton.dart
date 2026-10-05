import 'package:animego/core/Firebase.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Links out to services that can tell you more about an anime.
class SearchAnimeButton extends StatelessWidget {
  const SearchAnimeButton({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String? name;

  /// English-only prompt so the answer always comes back in one language.
  static const _chatGptPrompt =
      'Tell me about the anime "{name}". Identify its genres and original '
      'release year, and whether it is based on a manga, light novel, game, or '
      'another work, or is an original anime. Give a short spoiler-free story '
      'summary so I can decide whether it suits me. Reply in English. If '
      'details are uncertain, say so.';

  @override
  Widget build(BuildContext context) {
    final query = name ?? '';
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        AnimeFlatButton(
          onPressed: () {
            _open('https://www.google.com/search', {'q': query});
            FirebaseEventService().logUseGoogle();
          },
          child: Text('Google'),
        ),
        AnimeFlatButton(
          onPressed: () {
            _open('https://duckduckgo.com/', {'q': query});
            FirebaseEventService().logUseGoogle();
          },
          child: Text('DuckDuckGo'),
        ),
        AnimeFlatButton(
          onPressed: () {
            _open(
              'https://chatgpt.com/',
              {'q': _chatGptPrompt.replaceAll('{name}', query)},
            );
            FirebaseEventService().logUseChatGPT();
          },
          child: Text('ChatGPT'),
        ),
      ],
    );
  }

  /// Open [base] in the browser with the given query parameters.
  void _open(String base, Map<String, String> query) {
    final uri = Uri.parse(base).replace(queryParameters: query);
    launchUrlString(uri.toString());
  }
}
