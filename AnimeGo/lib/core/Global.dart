
import 'package:AnimeGo/core/parser/DomainParser.dart';

/// It handles global data
class Global {
  bool _hasInit = false;

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
      await DomainParser('http://gogoanimes.ai/').getNewDomain();
      _hasInit = true;
      return true;
    }
    
    return true;
  }
}