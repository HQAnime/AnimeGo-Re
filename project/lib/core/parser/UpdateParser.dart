import 'dart:convert';

import 'package:animego/core/model/GithubUpdate.dart';
import 'package:animego/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This gets data from my github api branch
class UpdateParser extends BasicParser {
  // The link is static so...
  UpdateParser()
      : super(
          'https://raw.githubusercontent.com/HenryQuan/AnimeGo-Re/api/version.json',
        );

  @override
  GithubUpdate parseHTML(Document? body) {
    final test = body?.body?.text;
    dynamic json;
    if (test != null) json = jsonDecode(test);
    return GithubUpdate.fromJson(json);
  }
}
