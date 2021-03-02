import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_model.dart';


class PetBloc {
  final _repo = Repository();
  final _petList = BehaviorSubject<PetListModel>();

  Observable<PetListModel> get getPetList => _petList.stream;

  getList() async {
    PetListModel petList = await _repo.getPetList();
    _petList.sink.add(petList);
  }

  dispose() {
    _petList.close();
  }
}

final petBloc = PetBloc();