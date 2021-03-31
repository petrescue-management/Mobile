// Repository <----- the central point from where the data will flow to the BLOC

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/resource/form/form_provider.dart';
import 'package:pet_rescue_mobile/resource/account/account_provider.dart';
import 'package:pet_rescue_mobile/resource/pet/pet_provider.dart';
import 'package:pet_rescue_mobile/resource/account/sign_in.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

class Repository {
  final accountProvider = AccountProvider();
  final signInProvider = FirebaseSignIn();
  final petProvider = PetProvider();
  final formProvider = FormProvider();

  Future<String> signIn() => signInProvider.signInWithGoogle();

  Future<FirebaseUser> getCurrentUser() => signInProvider.getCurrentUser();

  Future<void> signOut() => signInProvider.signOutGoogle();

  Future<String> getJWT(String firebaseToken, String deviceToken) =>
      accountProvider.getJWT(firebaseToken, deviceToken);

  Future<UserModel> getUserDetails() => accountProvider.getUserDetail();

  Future<PetListBaseModel> getPetListByType() => petProvider.getPetListByType();

  Future<String> uploadAvatar(File image, String uid) =>
      petProvider.uploadAvatar(image, uid);

  Future<bool> createRescueRequest(RescueReport rescueReport) =>
      formProvider.createRescueRequest(rescueReport);
}
