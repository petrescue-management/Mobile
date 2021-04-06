import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

class FormBloc {
  final _repo = Repository();
  final _createRescue = BehaviorSubject<bool>();
  final _createAdopt = BehaviorSubject<String>();

  Observable<bool> get createRescue => _createRescue.stream;
  Observable<String> get createAdopt => _createAdopt.stream;

  createRescueRequest(RescueReport rescueReport) async {
    bool isCreate = await _repo.createRescueRequest(rescueReport);
    _createRescue.sink.add(isCreate);
  }

  createAdoption(AdoptForm adoptForm) async {
    String isCreate = await _repo.createAdopttionRegistrationForm(adoptForm);
    _createAdopt.sink.add(isCreate);
  }

  dispose() {
    _createRescue.close();
    _createAdopt.close();
  }
}

final formBloc = FormBloc();
