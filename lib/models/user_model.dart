class UserModel {
  String email;
  String id;
  String lastName;
  String firstName;
  int gender;
  String phone;
  String imgUrl;
  String dob;

  UserModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    this.gender,
    this.phone,
    this.imgUrl,
    this.dob,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    print(json['dob']);
    return UserModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imgUrl'],
      dob: json['dob'],
    );
  }

  String get getImgUrl => imgUrl;
}
