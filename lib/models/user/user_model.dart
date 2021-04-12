class UserModel {
  String email;
  String id;
  String lastName;
  String firstName;
  int gender;
  String phone;
  String imgUrl;
  String dob;
  List<String> roles;
  //CenterProfile center;

  UserModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    this.gender,
    this.phone,
    this.imgUrl,
    this.dob,
    this.roles,
    //this.center,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    print(json['dob']);
    List<String> tempList = [];
    for (var i = 0; i < json['roles'].length; i++) {
      String tmpRole = json['roles'][i];
      tempList.add(tmpRole);
    }
    return UserModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imgUrl'],
      dob: json['dob'],
      roles: tempList,
      //center: CenterProfile.fromJson(json['center']),
    );
  }

  String get getImgUrl => imgUrl;
}

class CenterProfile {
  String centerName;

  CenterProfile({this.centerName});

  factory CenterProfile.fromJson(Map<dynamic, dynamic> json) {
    return CenterProfile(
      centerName: json['centerName'],
    );
  }
}
