// Repository <----- the central point from where the data will flow to the BLOC

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:pet_rescue_mobile/models/pet/adopted_list_base_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/models/center/center_base_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';
import 'package:pet_rescue_mobile/models/user/user_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';
import 'package:pet_rescue_mobile/models/user/volunteer_model.dart';

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

  // user
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

  // volunteer
  Future<bool> registrationVolunteer(VolunteerModel user) =>
      accountProvider.registrationVolunteer(user);

  Future<String> uploadVolunteer(File image, String uid) =>
      firebaseProvider.uploadVolunteer(image, uid);

  // center
  Future<CenterBaseModel> getCenterList() => centerProvider.getCenterList();

  // pet
  Future<PetListBaseModel> getPetListByType() => petProvider.getPetListByType();

  Future<File> getImageFileFromAssets(Asset asset) =>
      petProvider.getImageFileFromAssets(asset);

  Future<String> uploadRescueImage(File image, String uid) =>
      petProvider.uploadRescueImage(image, uid);

  Future<AdoptedListBaseModel> getAdoptedPetList() =>
      petProvider.getAdoptedPetList();

  // form
  Future<bool> createRescueRequest(RescueReport rescueReport) =>
      formProvider.createRescueRequest(rescueReport);

  Future<String> createAdopttionRegistrationForm(AdoptForm adoptForm) =>
      formProvider.createAdoptionRegistrionForm(adoptForm);

  Future<FinderFormBaseModel> getFinderFormList() =>
      formProvider.getFinderFormList();

  Future<AdoptionRegisFormBaseModel> getAdoptionRegistrationList() =>
      formProvider.getAdoptionRegisFormList();

  Future<bool> cancelFinderForm(String finderFormId) =>
      formProvider.cancelFinderForm(finderFormId);
}
