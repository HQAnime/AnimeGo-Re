import 'package:animego/core/source/hianime/HianimeSource.dart';

/// AniWatch is the original name of HiAnime; the code is the same, only the
/// mirror differs. Keeping it as a separate source gives the user a second
/// mirror to fall back on if one domain goes down.
class AniwatchSource extends HianimeSource {
  AniwatchSource({
    String baseUrl = 'https://hianimez.to/',
  }) : super(baseUrl: baseUrl, id: 'aniwatch', name: 'AniWatch');
}
