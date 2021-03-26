class PetModel {
  String petId;
  String centerId;
  String petName;
  String petBreed;
  String petFurColor;
  String imgUrl;
  String petAge;
  //int petStatus;
  int petGender;
  // int petWeight;
  // bool isVaccinated;
  // bool isSterilized;

  PetModel(pet) {
    petId = pet['petId'];
    centerId = pet['centerId'];
    petName = pet['petName'];
    imgUrl = pet['imgUrl'];
    petAge = pet['petAge'].toString();
    petGender = pet['petGender'];
    petBreed = pet['petBreedName'];
    petFurColor = pet['petFurColorName'];
  }
}
