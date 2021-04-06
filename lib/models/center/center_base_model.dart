import 'center_model.dart';

class CenterBaseModel {
  List<CenterModel> result;

  CenterBaseModel({
    this.result,
  });

  CenterBaseModel.fromJson(List<dynamic> json) {
    List<CenterModel> tmpList = [];
    for (var i = 0; i < json.length; i++) {
      CenterModel tmp = CenterModel(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}