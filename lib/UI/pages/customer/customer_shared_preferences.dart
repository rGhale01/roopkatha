import 'package:shared_preferences/shared_preferences.dart';

class CustomerSharedPreferences {
  static const _customerIDKey = 'customerID';
  static const _customerNameKey = 'customerName';
  static const _customerEmailKey = 'customerEmail';
  static const _authTokenKey = 'authToken';

  static Future<void> setCustomerID(String customerID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerIDKey, customerID);
  }

  static Future<String?> getCustomerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerIDKey);
  }

  static Future<void> setCustomerName(String customerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerNameKey, customerName);
  }

  static Future<String?> getCustomerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerNameKey);
  }

  static Future<void> setCustomerEmail(String customerEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerEmailKey, customerEmail);
  }

  static Future<String?> getCustomerEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerEmailKey);
  }

  static Future<void> setAuthToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, authToken);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> clearCustomerPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customerIDKey);
    await prefs.remove(_customerNameKey);
    await prefs.remove(_customerEmailKey);
    await prefs.remove(_authTokenKey);
  }
}