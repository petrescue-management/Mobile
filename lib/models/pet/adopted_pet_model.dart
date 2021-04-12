class AdoptedPetModel {
  String adoptionRegistrationId;
  Owner owner;
  int adoptionStatus;
  String adoptedAt;
  String returnedAt;
  // user info
  String username;
  String address;
  String email;
  String phone;
  String job;
  // pet info
  String petName;
  List<String> petImgUrl;
  String petBreedName;
  String petTypeName;
  String petColorName;

  AdoptedPetModel(pet) {
    this.adoptionRegistrationId = pet['adoptionRegistrationId'];
    this.owner = Owner.fromJson(pet['owner']);
    this.adoptionStatus = pet['adoptionStatus'];
    this.adoptedAt = pet['adoptedAt'];
    this.returnedAt = pet['returnedAt'];
    this.username = pet['username'];
    this.address = pet['address'];
    this.email = pet['email'];
    this.job = pet['job'];
    this.phone = pet['phone'];
    this.petName = pet['petName'];
    this.petImgUrl = getImgUrlList(pet['petImgUrl']);
    this.petBreedName = pet['petBreedName'];
    this.petTypeName = pet['petTypeName'];
    this.petColorName = pet['petColorName'];
  }

  List getImgUrlList(String imgUrl) {
    List<String> result = [];

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });

    tmp.removeLast();

    result = tmp;

    return result;
  }
}

class Owner {
  String userId;
  String userEmail;
  String lastName;
  String firstName;
  String phone;

  Owner({
    this.userId,
    this.userEmail,
    this.lastName,
    this.firstName,
    this.phone,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      userId: json['userId'],
      userEmail: json['userEmail'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      phone: json['userPhone'],
    );
  }
}
