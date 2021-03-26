import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

class FormBloc {
  final _repo = Repository();
  final _createRescue = BehaviorSubject<bool>();

  Observable<bool> get createRescue => _createRescue.stream;

  createRescueRequest(RescueReport rescueReport) async {
    bool isCreate = await _repo.createRescueRequest(rescueReport);
    _createRescue.sink.add(isCreate);
  }

  dispose() {
    _createRescue.close();
  }
}

final formBloc = FormBloc();
