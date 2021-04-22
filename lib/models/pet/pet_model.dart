class PetModel {
  String petProfileId;
  String petDocumentId;
  String petName;
  int petGender;
  String petAge;
  String petProfileDescription;
  String petBreedName;
  String petFurColorName;
  List<String> petImgUrl;
  String centerId;
  String centerName;
  String centerAdrress;
  String insertedAt;

  PetModel({
    this.petProfileId,
    this.petDocumentId,
    this.petName,
    this.petGender,
    this.petAge,
    this.petProfileDescription,
    this.petBreedName,
    this.petFurColorName,
    this.petImgUrl,
    this.centerId,
    this.centerName,
    this.centerAdrress,
    this.insertedAt,
  });

  PetModel.fromJson(Map<String, dynamic> json) {
    petProfileId = json['petProfileId'];
    petDocumentId = json['petDocumentId'];
    petName = json['petName'];
    petGender = json['petGender'];
    petAge = convertPetAge(json['petAge']);
    petProfileDescription = json['petProfileDescription'];
    petBreedName = json['petBreedName'];
    petFurColorName = json['petFurColorName'];
    centerId = json['centerId'];
    petImgUrl = getImgUrlList(json['petImgUrl']);
    centerName = json['centerName'];
    centerAdrress = json['centerAddress'];
    insertedAt = json['insertedAt'];
  }

  convertPetAge(int age) {
    if (age == 1) {
      return 'Nhỏ/Trẻ';
    } else if (age == 2) {
      return 'Vừa/Trưởng thành';
    } else if (age == 3) {
      return 'Lớn/Già';
    } else {
      return 'Không xác định';
    }
  }

  List getImgUrlList(String imgUrl) {
    List<String> tmp = imgUrl.split(';');

    List<String> result = [];
    
    tmp.forEach((item) {
      if (item != ';') {
        result.add(item);
      }
    });
    result.removeLast();

    return result;
  }
}
