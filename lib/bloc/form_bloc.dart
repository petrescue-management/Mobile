import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';

class FormBloc {
  final _repo = Repository();
  final _createRescue = BehaviorSubject<bool>();
  final _createAdopt = BehaviorSubject<String>();
  final _getFinderFormList = BehaviorSubject<FinderFormBaseModel>();
  final _getAdoptionRegisList = BehaviorSubject<AdoptionRegisFormBaseModel>();

  Observable<bool> get createRescue => _createRescue.stream;
  Observable<String> get createAdopt => _createAdopt.stream;
  Observable<FinderFormBaseModel> get getFinderFormList => _getFinderFormList.stream;
  Observable<AdoptionRegisFormBaseModel> get getAdoptRegisList => _getAdoptionRegisList.stream;

  createRescueRequest(RescueReport rescueReport) async {
    bool isCreate = await _repo.createRescueRequest(rescueReport);
    _createRescue.sink.add(isCreate);
  }

  createAdoption(AdoptForm adoptForm) async {
    String isCreate = await _repo.createAdopttionRegistrationForm(adoptForm);
    _createAdopt.sink.add(isCreate);
  }

  getFinderList() async {
    FinderFormBaseModel finderList = await _repo.getFinderFormList();
    _getFinderFormList.sink.add(finderList);
  }

  getAdoptRegistrationList() async {
    AdoptionRegisFormBaseModel regisList = await _repo.getAdoptionRegistrationList();
    _getAdoptionRegisList.sink.add(regisList);
  }

  dispose() {
    _createRescue.close();
    _createAdopt.close();
    _getFinderFormList.close();
    _getAdoptionRegisList.close();
  }
}

final formBloc = FormBloc();
