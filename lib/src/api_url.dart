class ApiUrl {
  static String apiUrl = 'https://petrescuecapston.azurewebsites.net';

  // user
  static String getJWT = '$apiUrl/jwt?';
  static String getUserDetail = '$apiUrl/api/users';
  static String updateUserDetail = '$apiUrl/api/users/update-profile';
  static String createVolunteerRegistrationFrom =
      '$apiUrl/api/volunteer-registration-forms/create-volunteer-registration-form';

  // pet
  static String getPetListByType =
      '$apiUrl/api/pet-profiles/get-pet-by-typename';
  static String getFurColorList =
      '$apiUrl/api/pet-profiles/get-all-pet-fur_colors';
  static String getAdoptedPet =
      '$apiUrl/api/pet-profiles/get-adoption-by-userid';
  static String createAdoptionReport =
      '$apiUrl/api/adoption-report-trackings/create-adoption-report-tracking';
  static String getAdoptionTrackingList =
      '$apiUrl/api/adoption-report-trackings/get-list-adoption-report-tracking-by-userid?petProfileId=';

  // form
  static String getSystemParameters =
      '$apiUrl/api/config/get-system-parameters';
  static String createRescueRequest =
      '$apiUrl/api/finder-forms/create-finder-form';
  static String getFinderForm =
      '$apiUrl/api/finder-forms/get-list-finder-form-by-userid';
  static String getFinderFormById =
      '$apiUrl/api/finder-forms/get-finder-form-by-id/';
  static String cancelFinderForm =
      '$apiUrl/api/finder-forms/cancel-finder-form';
  static String isExistAdoptRegistrationForm =
      '$apiUrl/api/adoption-registration-forms/check-exist-form?petProfileId=';
  static String createAdoptRegistrationForm =
      '$apiUrl/api/adoption-registration-forms/create-adoption-registration-form';
  static String getAdoptRegistrationForm =
      '$apiUrl/api/adoption-registration-forms/get-list-adoption-form-by-userid';
  static String getAdoptRegistrationFormById =
      '$apiUrl/api/adoption-registration-forms/get-adoption-registration-form-by-id/';
  static String cancelAdoptRegistrationForm =
      '$apiUrl/api/adoption-registration-forms/cancel-adoption-registration-form';
}
