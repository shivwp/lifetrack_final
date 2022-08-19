import 'dart:async';

import 'package:life_track/network/shared_pref/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This class is used to handle sharedPreference
class SharedPreferenceHelper {
  // SharedPreferences instance
  static Future<SharedPreferences>? _sharedPreference;

  //This creates the single instance by calling
  // the `_internal` constructor specified below
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  SharedPreferenceHelper._internal();

  //This is what's used to retrieve the instance through the app
  static SharedPreferenceHelper getInstance() {
    _sharedPreference ??= SharedPreferences.getInstance();
    return _singleton;
  }

  // General Methods: ----------------------------------------------------------
  Future<String?> get firebaseNotificationToken async {
    return _sharedPreference!.then((preference) {
      return preference.getString(PreferenceKeys.firebaseNotificationToken);
    });
  }

  Future<void> saveFirebaseNotificationToken(
      String firebaseNotificationToken) async {
    return _sharedPreference!.then((preference) {
      preference.setString(
          PreferenceKeys.firebaseNotificationToken, firebaseNotificationToken);
    });
  }

  Future<void> removeFirebaseNotificationToken() async {
    return _sharedPreference!.then((preference) {
      preference.remove(PreferenceKeys.firebaseNotificationToken);
    });
  }

  Future<String?> get apiToken async {
    return _sharedPreference!.then((preference) {
      return preference.getString(PreferenceKeys.apiToken);
    });
  }

  Future<void> saveApiToken(String value) async {
    return _sharedPreference!.then((preference) {
      preference.setString(PreferenceKeys.apiToken, value);
    });
  }

  Future<String?> get deviceToken async {
    return _sharedPreference!.then((preference) {
      return preference.getString(PreferenceKeys.deviceToken);
    });
  }

  Future<void> saveDeviceToken(String value) async {
    return _sharedPreference!.then((preference) {
      preference.setString(PreferenceKeys.deviceToken, value);
    });
  }

  // Login:---------------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference!.then((preference) {
      return preference.getBool(PreferenceKeys.isLoggedIn) ?? false;
    });
  }

  Future<void> saveIsLoggedIn(bool value) async {
    return _sharedPreference!.then((preference) {
      preference.setBool(PreferenceKeys.isLoggedIn, value);
    });
  }

  Future<String?> get userId async {
    return _sharedPreference!.then((preference) {
      return preference.getString(PreferenceKeys.userId);
    });
  }

  Future<void> saveUserId(String value) async {
    return _sharedPreference!.then((preference) {
      preference.setString(PreferenceKeys.userId, value);
    });
  }

  Future<int?> get userRole async {
    return _sharedPreference!.then((preference) {
      return preference.getInt(PreferenceKeys.userBUSINESSTYPE);
    });
  }

  Future<void> saveUserRole(int value) async {
    return _sharedPreference!.then((preference) {
      preference.setInt(PreferenceKeys.userBUSINESSTYPE, value);
    });
  }

  Future<double?> get latitude async {
    return _sharedPreference!.then((preference) {
      return preference.getDouble(PreferenceKeys.userBUSINESSTYPE);
    });
  }

  Future<void> saveLatitude(double value) async {
    return _sharedPreference!.then((preference) {
      preference.setDouble(PreferenceKeys.userLatitude, value);
    });
  }

  Future<double?> get selectedAreaLat async {
    return _sharedPreference!.then((preference) {
      return preference.getDouble(PreferenceKeys.selectedAreaLat);
    });
  }

  Future<void> saveSelectedAreaLat(double value) async {
    return _sharedPreference!.then((preference) {
      preference.setDouble(PreferenceKeys.selectedAreaLat, value);
    });
  }

  Future<double?> get selectedAreaLong async {
    return _sharedPreference!.then((preference) {
      return preference.getDouble(PreferenceKeys.selectedAreaLong);
    });
  }

  Future<void> saveSelectedAreaLong(double value) async {
    return _sharedPreference!.then((preference) {
      preference.setDouble(PreferenceKeys.selectedAreaLong, value);
    });
  }

  Future<double?> get longitude async {
    return _sharedPreference!.then((preference) {
      return preference.getDouble(PreferenceKeys.userBUSINESSTYPE);
    });
  }

  Future<void> saveLongitude(double value) async {
    return _sharedPreference!.then((preference) {
      preference.setDouble(PreferenceKeys.userLongitude, value);
    });
  }

  Future<String?> get userInfo async {
    return _sharedPreference!.then((preference) {
      return preference.getString(PreferenceKeys.userInfo);
    });
  }

  Future<void> saveUserInfo(String value) async {
    return _sharedPreference!.then((preference) {
      preference.setString(PreferenceKeys.userInfo, value);
    });
  }

  Future<bool> get isVerified async {
    return _sharedPreference!.then((preference) {
      return preference.getBool(PreferenceKeys.isVerified) ?? false;
    });
  }

  Future<void> saveIsVerified(bool value) async {
    return _sharedPreference!.then((preference) {
      preference.setBool(PreferenceKeys.isVerified, value);
    });
  }

  Future<String?> get userEmail async {
    return _sharedPreference!.then((preference) {
      return preference.getString(PreferenceKeys.userEmail);
    });
  }

  Future<void> saveUserEmail(String value) async {
    return _sharedPreference!.then((preference) {
      preference.setString(PreferenceKeys.userEmail, value);
    });
  }

  // Theme:------------------------------------------------------
  Future<bool> get isDarkMode {
    return _sharedPreference!.then((prefs) {
      return prefs.getBool(PreferenceKeys.isDarkMode) ?? false;
    });
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference!
        .then((prefs) => prefs.setBool(PreferenceKeys.isDarkMode, value));
  }

  // Language:---------------------------------------------------
  Future<String?> get currentLanguage {
    return _sharedPreference!.then((prefs) {
      return prefs.getString(PreferenceKeys.currentLanguage);
    });
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference!.then(
        (prefs) => prefs.setString(PreferenceKeys.currentLanguage, language));
  }

  //Clear preference:---------------------------------------------------
  Future<bool> clearPreference() async {
    _sharedPreference!.then((prefs) {
      prefs.clear();
    });
    return true;
  }
}
