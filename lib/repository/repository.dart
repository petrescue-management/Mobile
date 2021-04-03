// Repository <----- the central point from where the data will flow to the BLOC

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/models/center/center_base_model.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

import 'package:pet_rescue_mobile/resource/form/form_provider.dart';
import 'package:pet_rescue_mobile/resource/account/account_provider.dart';
import 'package:pet_rescue_mobile/resource/pet/pet_provider.dart';
import 'package:pet_rescue_mobile/resource/center/center_provider.dart';
import 'package:pet_rescue_mobile/resource/account/sign_in.dart';


class Repository {
  final accountProvider = AccountProvider();
  final firebaseProvider = FirebaseSignIn();
  final petProvider = PetProvider();
  final formProvider = FormProvider();
  final centerProvider = CenterProvider();

  Future<String> signIn() => firebaseProvider.signInWithGoogle();

  Future<FirebaseUser> getCurrentUser() => firebaseProvider.getCurrentUser();

  Future<void> signOut() => firebaseProvider.signOutGoogle();

  Future<String> getJWT(String firebaseToken, String deviceToken) =>
      accountProvider.getJWT(firebaseToken, deviceToken);

  Future<UserModel> getUserDetails() => accountProvider.getUserDetail();

  Future<String> uploadAvatar(File image, String uid) =>
      firebaseProvider.uploadAvatar(image, uid);

  Future<bool> updateUserDetails(UserModel user) =>
      accountProvider.updateUserDetail(user);

  Future<String> registrationVolunteer(UserModel user) =>
      accountProvider.registrationVolunteer(user);

  Future<CenterBaseModel> getCenterList() => centerProvider.getCenterList();

  Future<PetListBaseModel> getPetListByType() => petProvider.getPetListByType();

  Future<File> getImageFileFromAssets(Asset asset) =>
      petProvider.getImageFileFromAssets(asset);

  Future<String> uploadRescueImage(File image, String uid) =>
      petProvider.uploadRescueImage(image, uid);

  Future<bool> createRescueRequest(RescueReport rescueReport) =>
      formProvider.createRescueRequest(rescueReport);
}
