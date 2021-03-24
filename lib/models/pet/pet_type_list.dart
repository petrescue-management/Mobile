import 'package:pet_rescue_mobile/models/pet/pet_type.dart';

class PetTypeList {
  List<PetType> result;

  PetTypeList({
    this.result,
  });

  PetTypeList.fromJson(List<dynamic> json) {
    List<PetType> tmpList = [];

    for (var i = 0; i < json.length; i++) {
      PetType tmp = PetType(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
