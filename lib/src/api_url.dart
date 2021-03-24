class ApiUrl {
  static String getJWT = 'https://petrescueapi.azurewebsites.net/jwt?';
  static String getUserDetail = 'https://petrescueapi.azurewebsites.net/api/users';
  static String getPetList = 'https://petrescueapi.azurewebsites.net/api/get-pet?fields=detail&limit=-1';
  static String getPetListByType = 'https://petrescueapi.azurewebsites.net/api/get-pet?PetTypeName=';
  static String getPetTypes = 'https://petrescueapi.azurewebsites.net/api/get-all-pet-types';
}