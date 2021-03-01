// Repository <----- the central point from where the data will flow to the BLOC

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/resource/account/account_provider.dart';
import 'package:pet_rescue_mobile/resource/account/sign_in.dart';

class Repository {
  final accountProvider = AccountProvider();
  final signInProvider = FirebaseSignIn();

  Future<String> signIn() => signInProvider.signInWithGoogle();

  Future<FirebaseUser> getCurrentUser() => signInProvider.getCurrentUser();

  Future<void> signOut() => signInProvider.signOutGoogle();

  Future<String> getJWT(String firebaseToken) =>
      accountProvider.getJWT(firebaseToken);

  Future<UserModel> getUserDetails() =>
      accountProvider.getUserDetail();
}
