
import 'package:AnimeGo/core/parser/DomainParser.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// It handles global data
class Global {
  // Constants
  static final defaultDomain = 'https://gogoanimee.net';
  static final appVersion = '1.2.0';


  /// Whether the app has been init
  bool _hasInit = false;
  /// The domain that will be used globally
  String _domain;
  String getDomain() => _domain;
  updateDomain(String domain) {
    this._domain = domain;
    prefs.setString(websiteDomain, domain);
  }

  // Relating to local data
  SharedPreferences prefs;
  final websiteDomain = 'AnimeGo:Domain';

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