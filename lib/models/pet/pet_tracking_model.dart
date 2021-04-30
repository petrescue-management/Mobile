class PetTrackingModel {
  String adoptionReportTrackingId;
  String petProfileId;
  List<String> adoptionReportTrackingImgUrl;
  String description;
  String insertedAt;

  PetTrackingModel(report) {
    this.adoptionReportTrackingId = report['adoptionReportTrackingId'];
    this.petProfileId = report['petProfileId'];
    this.adoptionReportTrackingImgUrl = getImgUrlList(report['adoptionReportTrackingImgUrl']);
    this.description = report['description'];
    this.insertedAt = report['insertedAt'];
  }

  getImgUrlList(String imgUrl) {
    List<String> result = [];

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });

    tmp.removeLast();

    result = tmp;

    return result;
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
      PetTrackingModel tmp = PetTrackingModel(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
