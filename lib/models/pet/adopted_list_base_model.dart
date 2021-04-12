import 'package:pet_rescue_mobile/models/pet/adopted_pet_model.dart';

class AdoptedListBaseModel {
  List<AdoptedPetModel> result;

  AdoptedListBaseModel({
    this.result,
  });

  AdoptedListBaseModel.fromJson(List<dynamic> json) {
    List<AdoptedPetModel> tmpList = [];

    for (var i = 0; i < json.length; i++) {
      AdoptedPetModel tmp = AdoptedPetModel(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}