class RescueReport {
  int petAttribute;
  String imgReportUrl;
  String reportDescription;
  String reportLocation;
  double latitude, longitude;

  RescueReport({
    this.imgReportUrl,
    this.latitude,
    this.longitude,
    this.petAttribute,
    this.reportDescription,
    this.reportLocation,
  });

  factory RescueReport.fromJson(Map<String, dynamic> json) {
    return RescueReport(
      reportLocation: json['reportLocation'],
      imgReportUrl: json['imgReportUrl'],
      petAttribute: json['petAttribute'],
      reportDescription: json['reportDescription'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
