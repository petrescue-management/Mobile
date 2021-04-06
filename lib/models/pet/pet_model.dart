class PetModel {
  String petProfileId;
  String petDocumentId;
  String petName;
  int petGender;
  String petAge;
  String petProfileDescription;
  String petBreedName;
  String petFurColorName;
  String petImgUrl;
  String centerId;
  String centerName;
  String centerAdrress;

  PetModel(pet) {
    petProfileId = pet['petProfileId'];
    petDocumentId = pet['petDocumentId'];
    petName = pet['petName'];
    petGender = pet['petGender'];
    petAge = convertPetAge(pet['petAge']);
    petProfileDescription = pet['petProfileDescription'];
    petBreedName = pet['petBreedName'];
    petFurColorName = pet['petFurColorName'];
    centerId = pet['centerId'];
    petImgUrl = pet['petImgUrl'];
    centerName = pet['centerProfile']['centerName'];
    centerAdrress = pet['centerProfile']['centerAdrress'];
  }

  convertPetAge(int age) {
    if (age == 1) {
      return 'Bé con';
    } else if (age == 2) {
      return 'Thiếu niên';
    } else if (age == 3) {
      return 'Trưởng thành';
    } else {
      return 'Có tuổi';
    }
  }
}
