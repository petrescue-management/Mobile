class ApiUrl {
  // user
  static String getJWT = 'https://petrescueapi.azurewebsites.net/jwt?';
  static String getUserDetail =
      'https://petrescueapi.azurewebsites.net/api/users';
  static String updateUserDetail =
      'https://petrescueapi.azurewebsites.net/api/users/update-profile';
  static String createVolunteerRegistrationFrom =
      'https://petrescueapi.azurewebsites.net/api/create-volunteer-registration-form';
  static String getCenterList =
      'https://petrescueapi.azurewebsites.net/api/get-list-all-center';

  // pet
  static String getPetListByType =
      'https://petrescueapi.azurewebsites.net/api/get-pet-by-typename';
  static String getFurColorList =
      'https://petrescueapi.azurewebsites.net/api/get-all-pet-fur_colors';
  static String getAdoptedPet =
      'https://petrescueapi.azurewebsites.net/api/get-adoption-by-userId';
  static String createAdoptionReport =
      'https://petrescueapi.azurewebsites.net/api/create-adoption-report-tracking';
  static String getAdoptionTrackingList =
      'https://petrescueapi.azurewebsites.net/api/get-list-adoption-report-tracking-by-userid?petProfileId=';
      
  // form
  static String createRescueRequest =
      'https://petrescueapi.azurewebsites.net/api/create-finder-form';
  static String getFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-userid';
  static String cancelFinderForm =
      'https://petrescueapi.azurewebsites.net/api/cancel-finder-form';
  static String isExistAdoptRegistrationForm =
      'https://petrescueapi.azurewebsites.net/api/check-exist-form?petProfileId=';
  static String createAdoptRegistrationForm =
      'https://petrescueapi.azurewebsites.net/api/create-adoption-registration-form';
  static String getAdoptRegistrationForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-adoption-form-by-userID';
  static String cancelAdoptRegistrationForm =
      'https://petrescueapi.azurewebsites.net/api/cancel-adoption-registration-form';
}
