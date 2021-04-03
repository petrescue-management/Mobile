class PetModel {
  String petDocumentId;
  String petName;
  int petGender;
  String petAge;
  String petProfileDescription;
  String petBreedName;
  bool isVaccinated;
  bool isSterilized;
  String centerId;
  String petImgUrl;

  PetModel(pet) {
    petDocumentId = pet['petDocumentId'];
    petName = pet['petName'];
    petGender = pet['petGender'];
    petAge = convertPetAge(pet['petAge']);
    petProfileDescription = pet['petProfileDescription'];
    petBreedName = pet['petBreedName'];
    isVaccinated = pet['isVaccinated'];
    isSterilized = pet['isSterilized'];
    centerId = pet['centerId'];
    petImgUrl = pet['petImgUrl'];
  }

  convertPetAge(int age) {
    if (age == 1) {
      return 'Chó con/Mèo con';
    } else if (age == 2) {
      return 'Thiếu niên';
    } else if (age == 3) {
      return 'Trưởng thành';
    } else {
      return 'Có tuổi';
    }
  }
}
