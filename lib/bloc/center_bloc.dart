import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/center/center_base_model.dart';

class CenterBloc {
  final _repo = Repository();
  final _centerList = BehaviorSubject<CenterBaseModel>();

  Observable<CenterBaseModel> get getCenter => _centerList.stream;

  getCenterList() async {
    CenterBaseModel centerList = await _repo.getCenterList();
    _centerList.sink.add(centerList);
  }

  dispose() {
    _centerList.close();
  }
}

final centerBloc = CenterBloc();
