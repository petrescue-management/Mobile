import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

class PetType {
  String typeName;
  List<PetModel> listPet;

  PetType(petType) {
    typeName = petType['typeName'];
    List<PetModel> tempList = [];
    for (var i = 0; i < petType['result'].length; i++) {
      PetModel tmp = PetModel(petType['result'][i]);
      tempList.add(tmp);
    }
    listPet = tempList.cast<PetModel>();
  }
}
