import 'package:shared_preferences/shared_preferences.dart';

class CustomerSharedPreferences {
  // Keys for Shared Preferences
  static const customerIDKey = 'customerID';
  static const customerNameKey = 'customerName';
  static const customerEmailKey = 'customerEmail';
  static const authTokenKey = 'authToken';
  static const customerNumberKey = 'customerNumber';
  static const customerDOBKey = 'customerDOB'; // New Key for DOB
  static const customerGenderKey = 'customerGender'; // New Key for Gender
  static const profilePictureUrlKey = 'profilePictureUrl';

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

  static Future<String?> getCustomerNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerNumberKey);
  }

  static Future<String?> getCustomerDOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerDOBKey);
  }

  static Future<String?> getCustomerGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerGenderKey);
  }

  static Future<String?> getProfilePictureUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(profilePictureUrlKey);
  }

  // Save all customer data at once (Optional: Useful after login or signup)
  static Future<void> saveCustomerData({
    required String customerID,
    required String customerName,
    required String customerEmail,
    required String authToken,
    required String customerNumber,
    required String customerDOB, // New field for DOB
    required String customerGender, // New field for Gender
    required String profilePictureUrl,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(customerIDKey, customerID);
    await prefs.setString(customerNameKey, customerName);
    await prefs.setString(customerEmailKey, customerEmail);
    await prefs.setString(authTokenKey, authToken);
    await prefs.setString(customerNumberKey, customerNumber);
    await prefs.setString(customerDOBKey, customerDOB); // Save DOB
    await prefs.setString(customerGenderKey, customerGender); // Save Gender
    await prefs.setString(profilePictureUrlKey, profilePictureUrl); // Save Profile Picture URL

    // Debug statements to confirm data is saved
    print('Saved customer ID: $customerID');
    print('Saved customer name: $customerName');
    print('Saved customer email: $customerEmail');
    print('Saved auth token: $authToken');
    print('Saved customer number: $customerNumber');
    print('Saved customer DOB: $customerDOB');
    print('Saved customer gender: $customerGender');
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
    await prefs.remove(customerNumberKey);
    await prefs.remove(customerDOBKey); // Clear DOB
    await prefs.remove(customerGenderKey); // Clear Gender
    await prefs.remove(profilePictureUrlKey); // Clear Profile Picture URL
  }

  // Clear ALL preferences if needed (Optional)
  static Future<void> clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
