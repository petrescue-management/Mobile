import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_type_list.dart';

class PetBloc {
  final _repo = Repository();
  final _petList = BehaviorSubject<PetListModel>();
  final _petListByType = BehaviorSubject<PetListModel>();
  final _petTypeList = BehaviorSubject<PetTypeList>();

  Observable<PetListModel> get getPetList => _petList.stream;
  Observable<PetListModel> get getPetListByType => _petListByType.stream;
  Observable<PetTypeList> get getPetTypeList => _petTypeList.stream;

  getList() async {
    PetListModel petList = await _repo.getPetList();
    _petList.sink.add(petList);
  }

  getPetTypeNameList() async {
    PetTypeList typeList = await _repo.getPetTypeList();
    _petTypeList.sink.add(typeList);
  }

  getListByType(String typeName) async {
    PetListModel petList = await _repo.getPetListByType(typeName);
    _petList.sink.add(petList);
  }

  dispose() {
    _petList.close();
    _petListByType.close();
    _petTypeList.close();
  }
}

final petBloc = PetBloc();