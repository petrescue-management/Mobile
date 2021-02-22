import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'account_provider.dart';

class FirebaseSignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

//use the Google sign-in data to authenticate a FirebaseUser
//return that user
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    //google
    // ignore: unused_local_variable
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    // String tokenGoogle;
    // await user.getIdToken().then((value) => tokenGoogle = value.token);

    //firebase
    final FirebaseUser currentUser = await _auth.currentUser();
    String tokenFirebase;
    await currentUser.getIdToken().then((value) => tokenFirebase = value.token);

    if (currentUser != null) {
      print('Firebase:' + tokenFirebase);
      print('signInWithGoogle succeeded: $currentUser');

      var jwt = AccountProvider().getJWT(tokenFirebase);

      if (jwt != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        print("JWT in SP:" + sharedPreferences.getString('token'));

        return jwt;
      }
      // return '$currentUser';
    }
    return null;
  }

//sign out of the current Google account
  Future<void> signOutGoogle() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    print("User Signed Out");
  }
}
