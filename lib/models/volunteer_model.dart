class VolunteerModel {
  String email;
  String id;
  String lastName;
  String firstName;
  int gender;
  String phone;
  String imgUrl;
  String dob;
  String centerId;

  VolunteerModel({
    this.email,
    this.id,
    this.lastName,
    this.firstName,
    this.gender,
    this.phone,
    this.imgUrl,
    this.dob,
    this.centerId,
  });

  factory VolunteerModel.fromJson(Map<dynamic, dynamic> json) {
    print(json['dob']);
    return VolunteerModel(
      email: json['email'],
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imageUrl'],
      dob: json['dob'],
      centerId: json['centerId'],
    );
  }

  String get getImgUrl => imgUrl;
}
