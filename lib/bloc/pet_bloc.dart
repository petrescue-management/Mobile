import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

class PetBloc {
  final _repo = Repository();
  final _petListByType = BehaviorSubject<PetListBaseModel>();

  Observable<PetListBaseModel> get getPetListByType => _petListByType.stream;

  getListByType() async {
    PetListBaseModel petList = await _repo.getPetListByType();
    _petListByType.sink.add(petList);
  }

  dispose() {
    _petListByType.close();
  }
}

final petBloc = PetBloc();
