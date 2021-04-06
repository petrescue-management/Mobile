class CenterModel {
  String centerId;
  String centerName;
  String address;
  String imageUrl;
  int centerStatus;
  String phone;
  String email;

  CenterModel(center) {
    centerId = center['centerId'];
    centerName = center['centerName'];
    address = center['address'];
    imageUrl = center['imageUrl'];
    centerStatus = center['centerStatus'];
    phone = center['phone'];
    email = center['email'];
  }
}
