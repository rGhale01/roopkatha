import 'package:shared_preferences/shared_preferences.dart';

class ArtistSharedPreferences {
  // Keys
  static const _artistIDKey = 'artistID';
  static const _artistNameKey = 'artistName';
  static const _artistEmailKey = 'artistEmail';
  static const _authTokenKey = 'authToken';
  static const _artistPhoneNoKey = 'artistPhoneNo';
  static const _artistDOBKey = 'artistDOB';
  static const _artistGenderKey = 'artistGender';
  static const _profilePictureUrlKey = 'artistProfilePictureUrl';
  static const _artistBioKey = 'artistBio';


  // Setters
  static Future<void> setArtistID(String artistID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistIDKey, artistID);
  }

  static Future<void> setArtistName(String artistName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistNameKey, artistName);
  }

  static Future<void> setArtistEmail(String artistEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistEmailKey, artistEmail);
  }

  static Future<void> setAuthToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, authToken);
  }

  static Future<void> setArtistPhoneNo(String artistPhoneNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistPhoneNoKey, artistPhoneNo);
  }

  static Future<void> setArtistDOB(String artistDOB) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistDOBKey, artistDOB);
  }

  static Future<void> setArtistGender(String artistGender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistGenderKey, artistGender);
  }

  static Future<void> setProfilePictureUrl(String profilePictureUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilePictureUrlKey, profilePictureUrl);
  }
  // Bio setter
  static Future<void> setArtistBio(String bio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistBioKey, bio);
  }

// Bio getter
  static Future<String?> getArtistBio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistBioKey);
  }


  // Getters
  static Future<String?> getArtistID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistIDKey);
  }

  static Future<String?> getArtistName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistNameKey);
  }

  static Future<String?> getArtistEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistEmailKey);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<String?> getArtistPhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistPhoneNoKey);
  }

  static Future<String?> getArtistDOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistDOBKey);
  }

  static Future<String?> getArtistGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_artistGenderKey);
  }

  static Future<String?> getProfilePictureUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePictureUrlKey);
  }

  // Save all artist data
  static Future<void> saveArtistData(Map<String, dynamic> artistData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_artistIDKey, artistData['id'] ?? '');
    await prefs.setString(_artistNameKey, artistData['name'] ?? '');
    await prefs.setString(_artistEmailKey, artistData['email'] ?? '');
    await prefs.setString(_authTokenKey, artistData['authToken'] ?? '');
    await prefs.setString(_artistPhoneNoKey, artistData['phoneNo'] ?? '');
    await prefs.setString(_artistDOBKey, artistData['dob'] ?? '');
    await prefs.setString(_artistGenderKey, artistData['gender'] ?? '');
    await prefs.setString(_profilePictureUrlKey, artistData['profilePictureUrl'] ?? '');
  }

  // Fetch all artist details
  static Future<Map<String, dynamic>> fetchArtistDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_artistIDKey) ?? '',
      'name': prefs.getString(_artistNameKey) ?? '',
      'email': prefs.getString(_artistEmailKey) ?? '',
      'authToken': prefs.getString(_authTokenKey) ?? '',
      'phoneNo': prefs.getString(_artistPhoneNoKey) ?? '',
      'dob': prefs.getString(_artistDOBKey) ?? '',
      'gender': prefs.getString(_artistGenderKey) ?? '',
      'profilePictureUrl': prefs.getString(_profilePictureUrlKey) ?? '',
      'bio': prefs.getString(_artistBioKey) ?? '', // Add this line

    };
  }

  // Check if artist is logged in
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey) != null && prefs.getString(_artistIDKey) != null;
  }

  // Clear all artist preferences (logout)
  static Future<void> clearArtistPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_artistIDKey);
    await prefs.remove(_artistNameKey);
    await prefs.remove(_artistEmailKey);
    await prefs.remove(_artistPhoneNoKey);
    await prefs.remove(_artistDOBKey);
    await prefs.remove(_artistGenderKey);
    await prefs.remove(_profilePictureUrlKey);
    await prefs.remove(_authTokenKey);
    await prefs.remove(_artistBioKey); // Add this line

  }
}