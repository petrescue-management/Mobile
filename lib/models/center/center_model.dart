class CenterModel {
  String centerId;
  String centerName;
  String address;
  String imageUrl;
  int centerStatus;

  CenterModel(center) {
    centerId = center['centerId'];
    centerName = center['centerName'];
    address = center['address'];
    imageUrl = center['imageUrl'];
    centerStatus = center['centerStatus'];
  }
}
