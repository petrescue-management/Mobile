//import 'package:intl/intl.dart';

class UserModel {
  String email;
  String id;
  String lastName;
  String firstName;
  //DateFormat dob;
  String address;
  int gender;
  String phone;
  String imgUrl;

  UserModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    //this.dob,
    this.address,
    this.gender,
    this.phone,
    this.imgUrl
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      //dob: json['dob'],
      address: json['address'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imgUrl'],
    );
  }
}