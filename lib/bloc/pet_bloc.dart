import 'package:pet_rescue_mobile/models/pet/adopted_list_base_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

class PetBloc {
  final _repo = Repository();
  final _petListByType = BehaviorSubject<PetListBaseModel>();
  final _adoptedPetList = BehaviorSubject<AdoptedListBaseModel>();

  Observable<PetListBaseModel> get getPetListByType => _petListByType.stream;
  Observable<AdoptedListBaseModel> get getAdoptedPetList => _adoptedPetList.stream;

  getListByType() async {
    PetListBaseModel petList = await _repo.getPetListByType();
    _petListByType.sink.add(petList);
  }

  getAdoptedList() async {
    AdoptedListBaseModel petList = await _repo.getAdoptedPetList();
    _adoptedPetList.sink.add(petList);
  }

  dispose() {
    _petListByType.close();
    _adoptedPetList.close();
  }
}

final petBloc = PetBloc();
