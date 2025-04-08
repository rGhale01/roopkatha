import 'package:shared_preferences/shared_preferences.dart';

class CustomerSharedPreferences {
  // Keys for Shared Preferences
  static const customerIDKey = 'customerID';
  static const customerNameKey = 'customerName';
  static const customerEmailKey = 'customerEmail';
  static const authTokenKey = 'authToken';
  static const customerNumberKey = 'customerNumber'; // Added customer number key

  // Get individual fields
  static Future<String?> getCustomerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerIDKey);
  }

  static Future<String?> getCustomerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerNameKey);
  }

  static Future<String?> getCustomerEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerEmailKey);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }

  static Future<String?> getCustomerNumber() async { // Added method to get customer number
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerNumberKey);
  }

  // Save all customer data at once (Optional: Useful after login or signup)
  static Future<void> saveCustomerData({
    required String customerID,
    required String customerName,
    required String customerEmail,
    required String authToken,
    required String customerNumber, // Added customer number parameter
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(customerIDKey, customerID);
    await prefs.setString(customerNameKey, customerName);
    await prefs.setString(customerEmailKey, customerEmail);
    await prefs.setString(authTokenKey, authToken);
    await prefs.setString(customerNumberKey, customerNumber); // Saving customer number
  }

  // Check if customer is logged in
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey) != null && prefs.getString(customerIDKey) != null;
  }

  // Clear customer preferences (logout)
  static Future<void> clearCustomerPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(customerIDKey);
    await prefs.remove(customerNameKey);
    await prefs.remove(customerEmailKey);
    await prefs.remove(authTokenKey);
    await prefs.remove(customerNumberKey); // Removing customer number
  }

  // Clear ALL preferences if needed (Optional)
  static Future<void> clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
