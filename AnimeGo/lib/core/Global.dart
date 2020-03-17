/// It handles global data
class Global {
  // Singleton pattern 
  Global._init();
  static final Global _instance = new Global._init();

  // Use dart's factory constructor to implement this patternx
  factory Global() {
    return _instance;
  }

}