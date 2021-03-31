class PetModel {
  String petId;
  String petName;
  int petGender;
  String petAge;
  double petWeight;
  String petDescription;
  String petBreedName;
  String petFurColorName;
  bool isVaccinated;
  bool isSterilized;
  String centerId;
  String imgUrl;

  PetModel(pet) {
    petId = pet['petId'];
    petName = pet['petName'];
    petGender = pet['petGender'];
    petAge = convertPetAge(pet['petAge']);
    petWeight = pet['weight'];
    petDescription = pet['description'];
    petBreedName = pet['petBreedName'];
    petFurColorName = pet['petFurColorName'];
    isVaccinated = pet['isVaccinated'];
    isSterilized = pet['isSterilized'];
    centerId = pet['centerId'];
    imgUrl = pet['imgUrl'];
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
