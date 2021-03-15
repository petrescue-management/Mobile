class PetModel {
  String petId;
  String centerId;
  String petName;
  String petTypeName;
  String petBreed;
  String petFurColor;
  String imgUrl;
  //String petAge;
  int petStatus;
  int petGender;
  // int petWeight;
  // bool isVaccinated;
  // bool isSterilized;

  PetModel(pet) {
    petId = pet['petId'];
    centerId = pet['centerId'];
    petName = pet['petName'];
    petTypeName = pet['petTypeName'];
    imgUrl = pet['imageUrl'];
    //petAge = pet['petAge'];
    //petStatus = pet['petStatus'];
    //petGender = pet['petGender'];
    petBreed = pet['petBreedName'];
    petFurColor = pet['petFurColorName'];
  }
}