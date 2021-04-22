import 'package:rxdart/rxdart.dart';
import 'package:pet_rescue_mobile/models/user/user_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

class AccountBloc {
  final _repo = Repository();
  final _userDetails = BehaviorSubject<UserModel>();
  final _accountJWT = BehaviorSubject<String>();

  Observable<UserModel> get userDetail => _userDetails.stream;
  Observable<String> get accountJWT => _accountJWT.stream;

  getJWT(String fbToken, String deviceToken) async {
    String jwt = await _repo.getJWT(fbToken, deviceToken);
    _accountJWT.sink.add(jwt);
  }

  getDetail() async {
    UserModel user = await _repo.getUserDetails();
    _userDetails.sink.add(user);
  }


  dispose() {
    _userDetails.close();
    _accountJWT.close();
  }
}

final accountBloc = AccountBloc();
