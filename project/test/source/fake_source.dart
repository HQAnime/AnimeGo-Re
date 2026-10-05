import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:animego/core/source/AnimeSource.dart';

/// A minimal [AnimeSource] used by the tests so they never touch the network.
class FakeSource extends AnimeSource {
  @override
  String get id => 'fake';

  @override
  String get name => 'Fake Source';

  @override
  SourceKind get kind => SourceKind.streaming;

  @override
  bool get supportsBrowse => true;

  @override
  bool get supportsSearch => true;

  @override
  Future<List<AnimeInfo>> browse(BrowseKind kind, {int page = 1}) async => [];

  @override
  Future<List<AnimeInfo>> search(String keyword, {int page = 1}) async => [];

  @override
  Future<List<AnimeInfo>> category(String categoryLink, {int page = 1}) async =>
      [];

  @override
  Future<List<AnimeInfo>> genre(String genre, {int page = 1}) async => [];

  @override
  Future<AnimeDetailedInfo?> detail(BasicAnime anime) async => null;

  @override
  Future<List<EpisodeInfo>> episodes(EpisodeSection section) async => [];

  @override
  Future<OneEpisodeInfo?> episode(BasicAnime episode) async =>
      OneEpisodeInfo.create(
        name: 'Fake',
        link: episode.link,
        servers: [VideoServer.create(title: 'Fake', link: 'https://x')],
      );
}
