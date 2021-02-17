import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/repo/account/account_provider.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc {
  final _userDetail = BehaviorSubject<UserModel>();
  final _accountJWT = BehaviorSubject<String>();

  Observable<UserModel> get userDetail => _userDetail.stream;
  Observable<String> get accountJWT => _accountJWT.stream;
  
  getJWT(String token) async{
    String jwt = await AccountProvider().getJWT(token);
    _accountJWT.sink.add(jwt);
  }

  getDetail(String jwt) async {
    UserModel user = await AccountProvider().getUserDetail(jwt);
    _userDetail.sink.add(user);
  } 

  dispose() {
    _userDetail.close();
    _accountJWT.close();
  }
}