import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/views/adoption/card/pet_details.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/main.dart';

// ignore: must_be_immutable
class LoginRequest extends StatefulWidget {
  PetModel pet;

  LoginRequest({Key key, this.pet}) : super(key: key);

  @override
  _LoginRequestState createState() => _LoginRequestState();
}

class _LoginRequestState extends State<LoginRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color2, width: 3),
                    image: DecorationImage(
                      image: AssetImage(app_logo_notitle),
                    ),
                  ),
                ),
                Text(
                  "Bạn chưa đăng nhập vào tài khoản của bạn!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _signInButton(),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
        ),
      ],
    ));
  }

  final _repo = Repository();

  // loading
  Widget loading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<bool> _confirmPop() {
    Navigator.of(context).pop();
  }

  // sign in button
  Widget _signInButton() {
    return WillPopScope(
      onWillPop: _confirmPop,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: CustomRaiseButtonIcon(
          labelText: ' Đăng nhập với Google',
          assetName: google_logo,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    ProgressDialog(message: 'Đang kiểm tra tài khoản...'));

            _repo.signIn().then(
                  (value) => {
                    if (value == null || value.isEmpty)
                      loading(context)
                    else if (value != null && widget.pet != null)
                      {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(pet: widget.pet))),
                      }
                    else
                      {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp())),
                      }
                  },
                );
          },
        ),
      ),
    );
  }
}
