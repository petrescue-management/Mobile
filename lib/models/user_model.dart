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
    );
  }

  String get getImgUrl => imgUrl;
}
