
import 'dart:convert';

import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:AnimeGo/core/model/FavouriteAnime.dart';
import 'package:AnimeGo/core/model/WatchHistory.dart';
import 'package:AnimeGo/core/parser/DomainParser.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// It handles global data
class Global {
  // Constants
  static final defaultDomain = 'https://gogoanimee.io';
  static final appVersion = '1.2.1';
  static final github = 'https://github.com/HenryQuan/AnimeGo';
  static final email = 'mailto:development.henryquan@gmail.com?subject=[AnimeGo] ';


  /// Whether the app has been init
  bool _hasInit = false;
  /// The domain that will be used globally
  String _domain;
  String getDomain() => _domain;
  updateDomain(String domain) {
    this._domain = domain;
    prefs.setString(websiteDomain, domain);
  }

  /// History list
  WatchHistory _history = WatchHistory();
  List<BasicAnime> get historyList => _history.list;
  bool hasWatched(BasicAnime anime) => _history.contains(anime);
  void clearAll() => prefs.setString(watchHistory, 'null');
  void addToHistory(BasicAnime anime) {
    _history.add(anime);
    // Save
    prefs.setString(watchHistory, jsonEncode(_history.toJson()));
  }

  /// Favourite list
  FavouriteAnime _favourite = FavouriteAnime();
  List<BasicAnime> get favouriteList => _favourite.list;
  bool isFavourite(BasicAnime anime) => _favourite.contains(anime);
  void addToFavourite(BasicAnime anime) {
    _favourite.add(anime);
    // Save
    prefs.setString(favouriteAnime, jsonEncode(_favourite.toJson()));
  }

  // Relating to local data
  SharedPreferences prefs;
  final websiteDomain = 'AnimeGo:Domain';
  final watchHistory = 'AnimeGo:WatchHistory';
  final favouriteAnime = 'AnimeGo:FavouriteAnime';

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

      // Get currently saved domain, use default if it is null
      String currDomain = prefs.getString(websiteDomain) ?? Global.defaultDomain;
      print('Saved domain is $currDomain');

      // Load history and favourite anime
      String historyString = prefs.getString(watchHistory);
      if (historyString != null) {
        this._history = WatchHistory.fromJson(jsonDecode(historyString));
      }

      String favouriteString = prefs.getString(favouriteAnime);
      if (favouriteString != null) {
        this._favourite = FavouriteAnime.fromJson(jsonDecode(favouriteString));
      }

      // Get the latest domain
      String latestDomain = await DomainParser(currDomain).getNewDomain();
      updateDomain(latestDomain);
      print('The latest domain is $latestDomain');

      // Set the flag to true
      _hasInit = true;
    }
    
    return true;
  }
}