class FurColor {
  String petFurColorName;

  FurColor(pet) {
    this.petFurColorName = pet['petFurColorName'];
  }
}

class FurColorBaseModel {
  List<FurColor> result;

  FurColorBaseModel({
    this.result,
  });

  FurColorBaseModel.fromJson(List<dynamic> json) {
    List<FurColor> tmpList = [];

    for (var i = 0; i < json.length; i++) {
      FurColor tmp = FurColor(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}