import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

class PetListModel {
  List<PetModel> result;

  PetListModel({
    this.result
  });

  PetListModel.fromJson(Map<String, dynamic> json) {
    List<PetModel> tempList = [];
    for (var i = 0; i < json['result'].length; i++) {
      PetModel tmp = PetModel(json['result'][i]);
      tempList.add(tmp);
    }
    result = tempList;
  }

  List<PetModel> get getResult => result;
}