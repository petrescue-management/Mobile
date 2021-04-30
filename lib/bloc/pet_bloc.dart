import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/models/pet/adopted_list_base_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_fur_color.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

class PetBloc {
  final _repo = Repository();
  final _petListByType = BehaviorSubject<PetListBaseModel>();
  final _petFurColorList = BehaviorSubject<FurColorBaseModel>();
  final _adoptedPetList = BehaviorSubject<AdoptedListBaseModel>();

  Observable<PetListBaseModel> get getPetListByType => _petListByType.stream;
  Observable<FurColorBaseModel> get getPetFurColorList => _petFurColorList.stream;
  Observable<AdoptedListBaseModel> get getAdoptedPetList => _adoptedPetList.stream;

  getListByType() async {
    PetListBaseModel petList = await _repo.getPetListByType();
    _petListByType.sink.add(petList);
  }

  getFurColorList() async {
    FurColorBaseModel furColorList = await _repo.getPetFurColorList();
    _petFurColorList.sink.add(furColorList);
  }

  getAdoptedList() async {
    AdoptedListBaseModel petList = await _repo.getAdoptedPetList();
    _adoptedPetList.sink.add(petList);
  }

  dispose() {
    _petListByType.close();
    _petFurColorList.close();
    _adoptedPetList.close();
  }
}

final petBloc = PetBloc();
