import 'package:http/http.dart';

/// It gets the current domain and will be called when app opens
class DomainParser {
  final String _gogoanime;
  DomainParser(this._gogoanime);

  /// Replace http with https if https doesn't exist
  String? _replaceHttp(String? link) {
    if (link == null) return null;
    if (link.contains('https')) return link;
    return link.replaceAll('http', 'https');
  }

  /// Request to the domain currently saved and see if there is a new one
  Future<String> getNewDomain() async {
    String finalDomain = _gogoanime;

    try {
      String? newDomain = _replaceHttp(this._gogoanime);
      // WHen it is null, it means that there is no more redirect and it is the latest domain
      while (newDomain != null) {
        // Request but don't follow redirects
        final request = Request('GET', Uri.parse(newDomain))
          ..followRedirects = false;
        // Get response and get the new location
        final response = await Client().send(request);
        // Replace http with https because `http` doesn't redirect for some reasons
        newDomain = _replaceHttp(response.headers['location']);
        if (newDomain != null) {
          finalDomain = newDomain;
        }
      }

      return finalDomain;
    } catch (e) {
      print(e);
      return finalDomain;
    }
  }
}
