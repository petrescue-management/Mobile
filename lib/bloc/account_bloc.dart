import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:rxdart/rxdart.dart';

class AccountBloc {
  final _repo = Repository();
  final _userDetails = BehaviorSubject<UserModel>();
  final _accountJWT = BehaviorSubject<String>();
  final _updateUserDetails = BehaviorSubject<bool>();
  final _registrationVolunteer = BehaviorSubject<String>();

  Observable<UserModel> get userDetail => _userDetails.stream;
  Observable<String> get accountJWT => _accountJWT.stream;
  Observable<bool> get updateUserDetails => _updateUserDetails.stream;
  Observable<String> get registrationVolunteer => _registrationVolunteer.stream;

  getJWT(String fbToken, String deviceToken) async {
    String jwt = await _repo.getJWT(fbToken, deviceToken);
    _accountJWT.sink.add(jwt);
  }

  getDetail() async {
    UserModel user = await _repo.getUserDetails();
    _userDetails.sink.add(user);
  }

  updateUserDetail(UserModel user) async {
    bool result = await _repo.updateUserDetails(user);
    _updateUserDetails.sink.add(result);
  }

  regisVolunteer(UserModel user) async {
    String result = await _repo.registrationVolunteer(user);
    _registrationVolunteer.sink.add(result);
  }

  dispose() {
    _userDetails.close();
    _accountJWT.close();
    _updateUserDetails.close();
    _registrationVolunteer.close();
  }
}

final accountBloc = AccountBloc();
