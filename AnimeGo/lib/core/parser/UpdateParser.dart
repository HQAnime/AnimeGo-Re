import 'dart:convert';

import 'package:AnimeGo/core/model/GithubUpdate.dart';
import 'package:AnimeGo/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This gets data from my github api branch
class UpdateParser extends BasicParser {
  // The link is static so...
  UpdateParser() : super('https://raw.githubusercontent.com/HenryQuan/AnimeGo-Re/api/version.json');

  @override
  GithubUpdate parseHTML(Document body) {
    final json = jsonDecode(body.body.text);
    return GithubUpdate.fromJson(json);
  }
}
