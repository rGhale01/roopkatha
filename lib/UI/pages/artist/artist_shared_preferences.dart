import 'package:shared_preferences/shared_preferences.dart';

class ArtistSharedPreferences {
  static const _artistIDKey = 'artistID';
  static const _artistNameKey = 'artistName';
  static const _artistEmailKey = 'artistEmail';
  static const _authTokenKey = 'authToken';

  static Future<void> setArtistID(String artistID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistIDKey, artistID);
  }

  static Future<String?> getArtistID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistIDKey);
  }

  static Future<void> setArtistName(String artistName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistNameKey, artistName);
  }

  static Future<String?> getArtistName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistNameKey);
  }

  static Future<void> setArtistEmail(String artistEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistEmailKey, artistEmail);
  }

  static Future<String?> getArtistEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistEmailKey);
  }

  static Future<void> setAuthToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, authToken);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> clearArtistPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_artistIDKey);
    await prefs.remove(_artistNameKey);
    await prefs.remove(_artistEmailKey);
    await prefs.remove(_authTokenKey);
  }
}