import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/data.dart';

import 'package:pet_rescue_mobile/views/adoption/card/pet_details.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: mainColor, width: 3),
                    image: DecorationImage(
                      image: AssetImage(app_logo_withtitle),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      _signInButton(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: SizedBox(
                          child: loginNotice(context),
                        ),
                      ),
                    ],
                  ),
                ),
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

  // sign in button
  Widget _signInButton() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: CustomRaiseButtonIcon(
        labelText: ' Đăng nhập với Google',
        assetName: google_logo,
        onPressed: () {
          showDialog(context: context, builder: (context) => GifDialog());

          _repo.signIn().then(
                (value) => {
                  if (value == null || value.isEmpty)
                    loading(context)
                  else if (value != null && widget.pet != null)
                    {
                      Navigator.of(context).popUntil((route) => route.isFirst),
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp())),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(pet: widget.pet))),
                    }
                  else
                    {
                      Navigator.of(context).popUntil((route) => route.isFirst),
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp())),
                    }
                },
              );
        },
      ),
    );
  }
}
