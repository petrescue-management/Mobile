class RescueReport {
  int petAttribute;
  String phone;
  String finderFormImgUrl;
  String finderFormVideoUrl;
  String finderDescription;
  double latitude, longitude;

  RescueReport({
    this.finderFormImgUrl,
    this.finderFormVideoUrl,
    this.latitude,
    this.longitude,
    this.petAttribute,
    this.finderDescription,
    this.phone,
  });

  factory RescueReport.fromJson(Map<String, dynamic> json) {
    return RescueReport(
      finderFormImgUrl: json['finderFormImgUrl'],
      finderFormVideoUrl: json['finderFormVideoUrl'],
      petAttribute: json['petAttribute'],
      finderDescription: json['finderDescription'],
      latitude: json['lat'],
      longitude: json['lng'],
      phone: json['phone'],
    );
  }

  String get getImageUrl => finderFormImgUrl.toString();

  String get getVideoUrl => finderFormVideoUrl.toString();
}
