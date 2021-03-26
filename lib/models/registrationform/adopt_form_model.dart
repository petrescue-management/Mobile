class AdoptForm {
  String petId;
  String userName;
  String phoneNumber;
  String email;
  String job;
  String address;
  int houseType;
  int frequencyAtHome;
  int childAge;
  int havePet;
  int adoptionRegistrationStatus;
  bool haveChildren;
  bool haveAgreement;
  bool beViolentTendencies;

  AdoptForm({
    this.address,
    this.adoptionRegistrationStatus,
    this.beViolentTendencies,
    this.childAge,
    this.email,
    this.frequencyAtHome,
    this.haveAgreement,
    this.haveChildren,
    this.havePet,
    this.houseType,
    this.job,
    this.petId,
    this.phoneNumber,
    this.userName,
  });
}
