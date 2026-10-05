import 'dart:convert';

import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// Parses the HTML fragments returned by the HiAnime pages and API.
class HianimeParser {
  HianimeParser._();

  /// Extract the path (and query) of a link so it is independent of the mirror.
  static String? _toPath(String? href) {
    if (href == null || href.isEmpty) return null;
    final uri = Uri.tryParse(href);
    if (uri == null) return href;
    final path = uri.path;
    return uri.hasQuery ? '$path?${uri.query}' : path;
  }

  /// The anime id is the trailing number of a slug like `naruto-1335`.
  static String? animeIdFromSlug(String? slug) {
    if (slug == null) return null;
    final match = RegExp(r'-(\d+)(?:\?.*)?$').firstMatch(slug);
    return match?.group(1);
  }

  /// Parse a list of anime cards (search, home, most-popular, ...).
  static List<AnimeInfo> parseCards(String html) {
    final doc = html_parser.parse(html);
    final items = doc.getElementsByClassName('flw-item');
    final list = <AnimeInfo>[];
    for (final item in items) {
      final card = _parseCard(item);
      if (card != null) list.add(card);
    }
    return list;
  }

  static AnimeInfo? _parseCard(Element item) {
    final nameAnchor = item.getElementsByClassName('film-name').isNotEmpty
        ? item.getElementsByClassName('film-name').first.querySelector('a')
        : null;
    if (nameAnchor == null) return null;

    final poster = item.getElementsByClassName('film-poster-img');
    final cover = poster.isNotEmpty
        ? (poster.first.attributes['src'] ??
            poster.first.attributes['data-src'])
        : null;

    final eps = item.getElementsByClassName('tick-eps');
    final sub = item.getElementsByClassName('tick-sub');
    final dub = item.getElementsByClassName('tick-dub');
    final episode = eps.isNotEmpty
        ? eps.first.text.trim()
        : (sub.isNotEmpty ? sub.first.text.trim() : '??');

    return AnimeInfo.create(
      name: nameAnchor.attributes['title']?.trim() ?? nameAnchor.text.trim(),
      link: _toPath(nameAnchor.attributes['href']),
      coverImage: cover,
      episode: episode,
      isDUB: dub.isNotEmpty && sub.isEmpty,
      detailed: true,
    );
  }

  /// Parse an anime detail page.
  static AnimeDetailedInfo? parseDetail(String html) {
    final doc = html_parser.parse(html);
    final animeId = parseAnimeId(html);
    if (animeId == null) return null;

    final detail = doc.getElementsByClassName('anisc-detail');
    final name = detail.isNotEmpty
        ? detail.first.getElementsByClassName('film-name').firstOrNullText()
        : null;

    final poster = doc.getElementsByClassName('anisc-poster');
    final image = poster.isNotEmpty
        ? poster.first
            .getElementsByClassName('film-poster-img')
            .firstOrNull
            ?.attributes['src']
        : null;

    final overview = doc.getElementsByClassName('anisc-info');
    final summary = overview.isNotEmpty
        ? overview.first.querySelector('.item.w-hide .text')?.text.trim()
        : null;

    final info = _parseInfoItems(doc);
    final total = _parseTotalEpisodes(doc);

    return AnimeDetailedInfo.create(
      name: name,
      image: image,
      summary: (summary == null || summary.isEmpty) ? null : summary,
      released: info['Aired'],
      status: info['Status'],
      genre: _parseGenres(doc),
      lastEpisode: total,
      episodes: [
        EpisodeSection.create(
          episodeStart: '1',
          episodeEnd: total ?? '',
          payload: animeId,
        ),
      ],
    );
  }

  /// Parse the meta tag / content attribute holding the anime id.
  static String? parseAnimeId(String html) {
    final match = RegExp(
      r'<meta\s+name="hi-anime-id"\s+content="(\d+)"',
      caseSensitive: false,
    ).firstMatch(html);
    if (match != null) return match.group(1);
    final doc = html_parser.parse(html);
    final content = doc.getElementsByClassName('anis-content');
    if (content.isNotEmpty) {
      return content.first.attributes['data-anime-id'];
    }
    return null;
  }

  static Map<String, String> _parseInfoItems(Document doc) {
    final result = <String, String>{};
    for (final item in doc.getElementsByClassName('item-title')) {
      final head = item.getElementsByClassName('item-head');
      final name = item.getElementsByClassName('name');
      if (head.isEmpty || name.isEmpty) continue;
      final key = head.first.text.replaceAll(':', '').trim();
      result[key] = name.first.text.trim();
    }
    return result;
  }

  static List<AnimeGenre> _parseGenres(Document doc) {
    final list = <AnimeGenre>[];
    for (final item in doc.getElementsByClassName('item-list')) {
      final head = item.getElementsByClassName('item-head');
      if (head.isEmpty || !head.first.text.contains('Genres')) continue;
      for (final link in item.getElementsByTagName('a')) {
        final title = link.attributes['title'] ?? link.text.trim();
        if (title.isNotEmpty) list.add(AnimeGenre(title));
      }
    }
    return list;
  }

  static String? _parseTotalEpisodes(Document doc) {
    final eps = doc.getElementsByClassName('tick-eps');
    if (eps.isEmpty) return null;
    return eps.first.text.trim();
  }

  /// Parse the episode list HTML fragment (from the episode/list JSON).
  static List<EpisodeInfo> parseEpisodes(String html) {
    final doc = html_parser.parse(html);
    final list = <EpisodeInfo>[];
    for (final anchor in doc.getElementsByClassName('ep-item')) {
      final id = anchor.attributes['data-id'];
      final number = anchor.attributes['data-number'];
      final href = _toPath(anchor.attributes['href']);
      if (id == null || href == null) continue;
      final link = '$href${href.contains('?') ? '&' : '?'}epnum=$number';
      list.add(
        EpisodeInfo.create(
          name: 'Episode ${number ?? '?'}',
          link: link,
        ),
      );
    }
    return list;
  }

  /// Parse the server list HTML fragment (from the episode/servers JSON).
  static List<VideoServer> parseServers(String html) {
    final doc = html_parser.parse(html);
    final list = <VideoServer>[];
    for (final item in doc.getElementsByClassName('server-item')) {
      final hash = item.attributes['data-hash'];
      if (hash == null) continue;
      final url = _decodeBase64(hash);
      if (url == null || url.isEmpty) continue;
      final name = item.attributes['data-server-name'] ?? 'Server';
      final type = (item.attributes['data-type'] ?? '').toUpperCase();
      list.add(
        VideoServer.create(
          title: type.isEmpty ? name : '$name ($type)',
          link: url,
          isEmbed: true,
        ),
      );
    }
    return list;
  }

  static String? _decodeBase64(String value) {
    try {
      return utf8.decode(base64.decode(base64.normalize(value)));
    } catch (e) {
      return null;
    }
  }
}

extension _FirstOrNull on List<Element> {
  Element? get firstOrNull => isEmpty ? null : first;
}

extension _FirstOrNullText on List<Element> {
  String? firstOrNullText() {
    if (isEmpty) return null;
    final text = first.text.trim();
    return text.isEmpty ? null : text;
  }
}
