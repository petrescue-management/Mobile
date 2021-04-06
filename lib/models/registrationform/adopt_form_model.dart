class AdoptForm {
  String petProfileId;
  String userName;
  String phone;
  String email;
  String job;
  String dob;
  String address;
  int houseType;
  int frequencyAtHome;
  bool haveChildren;
  String childAge;
  bool beViolentTendencies;
  bool haveAgreement;
  int havePet;

  AdoptForm({
    this.petProfileId,
    this.userName,
    this.phone,
    this.email,
    this.job,
    this.dob,
    this.address,
    this.houseType,
    this.frequencyAtHome,
    this.haveChildren,
    this.childAge,
    this.beViolentTendencies,
    this.haveAgreement,
    this.havePet,
  });

  factory AdoptForm.fromJson(Map<String, dynamic> json) {
    return AdoptForm(
      petProfileId: json['petProfileId'],
      userName: json['userName'],
      phone: json['phone'],
      email: json['email'],
      job: json['job'],
      dob: json['dob'],
      address: json['address'],
      houseType: json['houseType'],
      frequencyAtHome: json['frequencyAtHome'],
      haveChildren: json['haveChildren'],
      childAge: json['childAge'],
      beViolentTendencies: json['beViolentTendencies'],
      haveAgreement: json['haveAgreement'],
      havePet: json['havePet'],
    );
  }
}
