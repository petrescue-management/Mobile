class UserModel {
  String email;
  String id;
  String lastName;
  String firstName;
  DateTime dob;
  String address;
  int gender;
  String phone;

  UserModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    this.dob,
    this.address,
    this.gender,
    this.phone
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastname'],
      firstName: json['firstname'],
      dob: json['dob'],
      address: json['address'],
      gender: json['gender'],
      phone: json['phone']
    );
  }
}