import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

class PetListModel {
  List<PetModel> petList = [];

  PetListModel({
    this.petList
  });

  factory PetListModel.fromJson(Map<String, dynamic> json) {
    return PetListModel(
     
    );
  }
}