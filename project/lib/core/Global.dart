import 'dart:convert';

import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/FavouriteAnime.dart';
import 'package:animego/core/model/GithubUpdate.dart';
import 'package:animego/core/model/WatchHistory.dart';
import 'package:animego/core/parser/DomainParser.dart';
import 'package:animego/core/parser/UpdateParser.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// It handles global data
class Global {
  // Constants
  static final defaultDomain = 'https://gogoanimes.to';
  static final appVersion = '1.3.1';
  static final github = 'https://github.com/HenryQuan/AnimeGo';
  static final latestRelease =
      'https://github.com/HenryQuan/AnimeGo/release/latest';
  static final email =
      'mailto:development.henryquan@gmail.com?subject=[AnimeGo $appVersion] ';

  /// Whether the app has been init
  bool _hasInit = false;

  /// The domain that will be used globally
  String? _domain;
  // Return default if null
  String getDomain() => _domain ?? Global.defaultDomain;
  updateDomain(String domain) {
    this._domain = domain;
    prefs.setString(websiteDomain, domain);
  }

  /// Relating to app update
  bool _hasChecked = false;
  late DateTime _lastDate;
  late GithubUpdate _update;

  /// Whwther dub anime should be hidden
  bool? _hideDUB;
  bool? get hideDUB => _hideDUB;
  set hideDUB(bool? value) {
    this._hideDUB = value;
    prefs.setBool(hideDubAnime, _hideDUB ?? false);
  }

  /// History list
  WatchHistory _history = WatchHistory();
  List<BasicAnime?> get historyList => _history.list;
  bool hasWatched(BasicAnime? anime) => _history.contains(anime);
  void clearAll() => prefs.setString(watchHistory, 'null');
  void addToHistory(BasicAnime anime) {
    print('Adding ${anime.toString()} to history');
    _history.add(anime);
    // Save
    prefs.setString(watchHistory, jsonEncode(_history.toJson()));
  }

  /// Favourite list
  FavouriteAnime _favourite = FavouriteAnime();
  List<BasicAnime?> get favouriteList => _favourite.list;
  bool isFavourite(BasicAnime? anime) => _favourite.contains(anime);
  void removeFromFavourite(BasicAnime? anime) {
    _favourite.remove(anime);
    prefs.setString(favouriteAnime, jsonEncode(_favourite.toJson()));
  }

  void addToFavourite(BasicAnime? anime) {
    _favourite.add(anime);
    // Save
    prefs.setString(favouriteAnime, jsonEncode(_favourite.toJson()));
  }

  // Relating to local data
  late SharedPreferences prefs;
  final websiteDomain = 'AnimeGo:Domain';
  final watchHistory = 'AnimeGo:WatchHistory';
  final favouriteAnime = 'AnimeGo:FavouriteAnime';
  final hideDubAnime = 'AnimeGo:HideDUB';
  final lastUpdateDate = 'AnimeGo:LastUpdateDate';

  // Singleton pattern
  Global._init();
  static final Global _instance = new Global._init();

  // Use dart's factory constructor to implement this patternx
  factory Global() {
    return _instance;
  }

  Future<bool> init() async {
    // This method can be called multiple times, only init if hasn't
    if (!_hasInit) {
      // Setup shared preference
      prefs = await SharedPreferences.getInstance();

      // Check if it needs to check for update
      String? dateString = prefs.getString(lastUpdateDate);
      if (dateString == null) {
        dateString = DateTime.now().toString();
        prefs.setString(lastUpdateDate, dateString);
      }
      this._lastDate = DateTime.parse(dateString);

      // Get currently saved domain, use default if it is null
      String currDomain =
          prefs.getString(websiteDomain) ?? Global.defaultDomain;
      print('Saved domain is $currDomain');

      // Load history and favourite anime
      String? historyString = prefs.getString(watchHistory);
      if (historyString != null) {
        this._history = WatchHistory.fromJson(jsonDecode(historyString));
      }

      String? favouriteString = prefs.getString(favouriteAnime);
      if (favouriteString != null) {
        this._favourite = FavouriteAnime.fromJson(jsonDecode(favouriteString));
      }

      // Set to false by default
      this._hideDUB = prefs.getBool(hideDubAnime) ?? false;

      // Get the latest domain
      String latestDomain = await DomainParser(currDomain).getNewDomain();
      updateDomain(latestDomain);
      print('The latest domain is $latestDomain');

      // Set the flag to true
      _hasInit = true;
    }

    return true;
  }

  /// Check for update from github
  Future<void> checkForUpdate(BuildContext context,
      {bool force = false}) async {
    // Check if the difference is at least 30 days
    if (!force && _lastDate.difference(DateTime.now()).inDays < 15) {
      print('No need to check for update');
      return;
    }

    // Only check if not checked yet
    if (!_hasChecked) {
      _hasChecked = true;
      final parser = UpdateParser();
      this._update = parser.parseHTML(
        await parser.downloadHTML(),
      );
    }

    if (_update.version != appVersion) {
      print('There is an update');
      // Update the date
      prefs.setString(lastUpdateDate, _lastDate.toString());
      // Show update dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          title: Text('Version ${_update.version ?? '??'}'),
          content: Text(_update.newFeatures ?? 'Something is very wrong...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () => launchUrlString(_update.downloadLink ??
                  'https://github.com/HenryQuan/AnimeGo-Re/releases/latest'),
              child: Text('Update now (Android only)'),
            ),
          ],
        ),
      );
    } else {
      print('Up to date');
      // Only show this in force mode
      if (force) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Update to date'),
            content: Text('You are using the latest version.'),
            actions: [
              AnimeFlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }
}
