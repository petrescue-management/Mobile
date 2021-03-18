class UserModel {
  String email;
  String id;
  String lastName;
  String firstName;
  String address;
  int gender;
  String phone;
  String imgUrl;
  String dob;

  UserModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    this.address,
    this.gender,
    this.phone,
    this.imgUrl,
    this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      address: json['address'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imgUrl'],
      dob: json['dob'].toString(),
    );
  }
}
