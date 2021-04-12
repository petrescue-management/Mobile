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
  static String getAdoptedPet =
      'https://petrescueapi.azurewebsites.net/api/get-adoption-by-userId';

  // form
  static String createRescueRequest =
      'https://petrescueapi.azurewebsites.net/api/create-finder-form';
  static String createAdoptRegistrationForm =
      'https://petrescueapi.azurewebsites.net/api/create-adoption-registration-form';
  static String getFinderForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-finder-form-by-userid';
  static String getAdoptRegistrationForm =
      'https://petrescueapi.azurewebsites.net/api/get-list-adoption-form-by-userID';
  static String cancelFinderForm =
      'https://petrescueapi.azurewebsites.net/api/update-finder-form-status';
}
