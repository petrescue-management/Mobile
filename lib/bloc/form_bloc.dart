import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';

class FormBloc {
  final _repo = Repository();
  final _getFinderFormList = BehaviorSubject<FinderFormBaseModel>();
  final _getAdoptionRegisList = BehaviorSubject<AdoptionRegisFormBaseModel>();

  Observable<FinderFormBaseModel> get getFinderFormList => _getFinderFormList.stream;
  Observable<AdoptionRegisFormBaseModel> get getAdoptRegisList => _getAdoptionRegisList.stream;

  getFinderList() async {
    FinderFormBaseModel finderList = await _repo.getFinderFormList();
    _getFinderFormList.sink.add(finderList);
  }

  getAdoptRegistrationList() async {
    AdoptionRegisFormBaseModel regisList = await _repo.getAdoptionRegistrationList();
    _getAdoptionRegisList.sink.add(regisList);
  }

  dispose() {
    _getFinderFormList.close();
    _getAdoptionRegisList.close();
  }
}

final formBloc = FormBloc();
