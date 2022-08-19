//This class is used to handle api configs
class ApiConfig {
  ApiConfig._(); // this basically makes it so you can't instantiate this class

  //API Base URL's
  //For Local
  static const String baseUrlDev =
      'http://lifetrackllc.xyz/api/';
      // 'http://54.70.237.161/api/';


  //For Live
  static const String baseUrlLive = 'https://newsapi.org/v2/';

  //For Uat
  static const String baseUrlUat = 'https://newsapi.org/v2/';

  //Apis names
  static const String topHeadlinesApi = 'top-headlines';
}
