import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/main.dart';

class LoginRequest extends StatefulWidget {
  const LoginRequest({Key key}) : super(key: key);

  @override
  _LoginRequestState createState() => _LoginRequestState();
}

class _LoginRequestState extends State<LoginRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
                tag: 'hero',
                child: SizedBox(height: 250, child: Image.asset(app_logo))),
            Text(
                "You haven't sign in to your account!!"),
            _signInButton(),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    ));
  }

  final _repo = Repository();

  // sign in button
  Widget _signInButton() {
    return OutlineButton(
      onPressed: () {
        _repo.signIn().then((value) => {
              if (value == null)
                print("null value")
              else
                {
                  Navigator.of(context).popUntil((route) => route.isFirst),
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => MyApp()))
                }
            });
      },
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(google_logo), height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
