class VolunteerModel {
  String email;
  String id;
  String lastName;
  String firstName;
  int gender;
  String phone;
  String imgUrl;
  String dob;

  VolunteerModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    this.gender,
    this.phone,
    this.imgUrl,
    this.dob,
  });

  factory VolunteerModel.fromJson(Map<dynamic, dynamic> json) {
    return VolunteerModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imageUrl'],
      dob: json['dob'],
    );
  }

  String get getImgUrl => imgUrl;
}
