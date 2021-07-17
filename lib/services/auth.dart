import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/helper_functions/sharedpref_helper.dart';
import 'package:messenger/services/database.dart';
import 'package:messenger/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
    );

    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    User? user = userCredential.user;

    if(userCredential != null){
      SharedPreferenceHelper().saveUserEmail(user!.email!);
      SharedPreferenceHelper().saveUserId(user.uid);
      SharedPreferenceHelper().saveUserName(user.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(user.displayName!);
      SharedPreferenceHelper().saveUserProfileUrl(user.photoURL!);

      Map<String, dynamic> userInfoMap = {
        "email" : user.email,
        "username" : user.email!.replaceAll("@gmail.com", ""),
        "name" : user.displayName,
        "imgUrl" : user.photoURL
      };

      DatabaseMethods().addUserInfoToDB(user.uid, userInfoMap).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return Home();
        }));
      });
    }
  }

  Future signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    await auth.signOut();
  }
}