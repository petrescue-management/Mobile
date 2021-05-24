// Repository <----- the central point from where the data will flow to the BLOC

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:pet_rescue_mobile/models/pet/adopted_list_base_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_fur_color.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_tracking_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';
import 'package:pet_rescue_mobile/models/system_config.dart';
import 'package:pet_rescue_mobile/models/user/volunteer_model.dart';
import 'package:pet_rescue_mobile/models/user/user_model.dart';

import 'package:pet_rescue_mobile/resource/form/form_provider.dart';
import 'package:pet_rescue_mobile/resource/account/sign_in.dart';
import 'package:pet_rescue_mobile/resource/account/account_provider.dart';
import 'package:pet_rescue_mobile/resource/pet/pet_provider.dart';

class Repository {
  final accountProvider = AccountProvider();
  final firebaseProvider = FirebaseSignIn();
  final petProvider = PetProvider();
  final formProvider = FormProvider();

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
  Future<String> registrationVolunteer(VolunteerModel user) =>
      accountProvider.registrationVolunteer(user);

  Future<String> uploadVolunteer(File image, String uid) =>
      firebaseProvider.uploadVolunteer(image, uid);

  // pet
  Future<PetListBaseModel> getPetListByType() => petProvider.getPetListByType();

  Future<FurColorBaseModel> getPetFurColorList() =>
      petProvider.getPetFurColorList();

  Future<bool> getRescueImage(String imgUrl) =>
      petProvider.getRescueImage(imgUrl);

  Future<AdoptedListBaseModel> getAdoptedPetList() =>
      petProvider.getAdoptedPetList();

  Future<bool> createPetTracking(
          String petProfileId, String description, String imgUrl) =>
      petProvider.createPetTracking(petProfileId, description, imgUrl);

  Future<String> uploadTrackingImage(File image, String uid) =>
      petProvider.uploadTrackingImage(image, uid);

  Future<PetTrackingBaseModel> getAdoptionTrackingList(String petProfileId) =>
      petProvider.getAdoptionTrackingList(petProfileId);

  // form
  Future<File> getImageFileFromAssets(Asset asset) =>
      petProvider.getImageFileFromAssets(asset);

  Future<String> uploadRescueImage(File image, String uid) =>
      petProvider.uploadRescueImage(image, uid);

  Future<String> uploadRescueVideo(File video, String uid) =>
      petProvider.uploadRescueVideo(video, uid);

  Future<ConfigModel> getNumberOfImage() => formProvider.getNumberOfImage();

  Future<bool> createRescueRequest(RescueReport rescueReport) =>
      formProvider.createRescueRequest(rescueReport);

  Future<String> checkExistAdoptionRegistrationForm(String petProfileId) =>
      formProvider.checkExistAdoptionRegistrationForm(petProfileId);

  Future<String> createAdoptionRegistrationForm(AdoptForm adoptForm) =>
      formProvider.createAdoptionRegistrationForm(adoptForm);

  Future<FinderFormBaseModel> getFinderFormList() =>
      formProvider.getFinderFormList();

  Future<FinderForm> getFinderFormById(String finderId) =>
      formProvider.getFinderFormById(finderId);

  Future<AdoptionRegisFormBaseModel> getAdoptionRegistrationList() =>
      formProvider.getAdoptionRegisFormList();

  Future<AdoptionRegisForm> getAdoptRegistrationFormById(
          String adoptionRegistrationId) =>
      formProvider.getAdoptRegistrationFormById(adoptionRegistrationId);

  Future<bool> cancelFinderForm(String finderFormId, String reason) =>
      formProvider.cancelFinderForm(finderFormId, reason);

  Future<bool> cancelAdoptionRegistrationForm(
          String adoptionRegistrationFormId, String reason) =>
      formProvider.cancelAdoptionRegistrationForm(
          adoptionRegistrationFormId, reason);
}
