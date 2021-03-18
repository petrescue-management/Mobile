class PetModel {
  String petId;
  String centerId;
  String petName;
  String petTypeName;
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
    petTypeName = pet['petType']['petTypeName'];
    imgUrl = pet['imageUrl'];
    petAge = getPetAge(pet['petAge']);
    petGender = pet['petGender'];
    petBreed = pet['petBreedName'];
    petFurColor = pet['petFurColorName'];
  }

  String getPetAge(int petAge) {
    if (petAge == 1) {
      if (petTypeName == 'Dog')
        return 'Chó con';
      else
        return 'Mèo con';
    } else if (petAge == 2)
      return 'Trưởng thành';
    else if (petAge == 3)
      return 'Lớn tuổi';
    else
      return 'Chưa biết';
  }
}
