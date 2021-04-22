class PetTrackingModel {
  String petProfileId;
  String adoptionReportImage;
  String description;
  String insertedAt;

  PetTrackingModel({
    this.petProfileId,
    this.adoptionReportImage,
    this.description,
    this.insertedAt,
  });

  factory PetTrackingModel.fromJson(Map<String, dynamic> json) {
    return PetTrackingModel(
      petProfileId: json['petProfileId'],
      adoptionReportImage: json['imageUrl'],
      description: json['description'],
      insertedAt: json['insertedAt'],
    );
  }
}

class PetTrackingBaseModel {
  List<PetTrackingModel> result;

  PetTrackingBaseModel({
    this.result,
  });

  PetTrackingBaseModel.fromJson(List<dynamic> json) {
    List<PetTrackingModel> tmpList = [];

    for (var i = 0; i < json.length; i++) {
      PetTrackingModel tmp = PetTrackingModel.fromJson(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}