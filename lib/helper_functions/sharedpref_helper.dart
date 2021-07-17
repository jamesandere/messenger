import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

  static String userId = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayName = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";

  //save data
  Future<bool> saveUserName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userId, userId);
  }

  Future<bool> saveDisplayName(String userDisplayName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(displayName, userDisplayName);
  }

  Future<bool> saveUserProfileUrl(String userProfilePic) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userProfilePicKey, userProfilePic);
  }

  //get data
  Future<String?> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userId);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(displayName);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userProfilePicKey);
  }
}