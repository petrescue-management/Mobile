import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/src/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';

class PetDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  String id;
  Color color;
  DetailsScreen({this.id, this.color});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _repo = Repository();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    String petName = '';
    String breed = '';
    String age = '';
    String gender = '';
    String imagePath = '';
    dogs.forEach((dog) {
      if (dog['id'] == widget.id) {
        petName = dog['name'];
        breed = dog['breed'];
        age = dog['age'];
        gender = dog['gender'];
        imagePath = dog['imagePath'];
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                    color: widget.color,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: widget.id,
                            child: Image.asset(
                              imagePath,
                              width: size.width * 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                            style: TextStyle(
                              color: fadedBlack,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 42,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.chevron_left),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 100,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: customShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        petName,
                        style: TextStyle(
                          color: fadedBlack,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        gender == 'female'
                            ? FontAwesomeIcons.venus
                            : FontAwesomeIcons.mars,
                        size: 22,
                        color: Colors.black54,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        breed,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        age,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: EdgeInsets.all(20),
                    child: FutureBuilder<FirebaseUser>(
                      future: _repo.getCurrentUser(),
                      builder: (BuildContext context,
                          AsyncSnapshot<FirebaseUser> snapshot) {
                        return CustomButton(
                          label: 'Adopt',
                          onTap: () {
                            if (snapshot.hasError) {
                              return waitDialog(context);
                            } else if (snapshot.data == null) {
                              return infoDialog(context,
                                  "Please log in to adopt this pet!!",
                                  neutralAction: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginRequest()));
                              });
                            } else {
                              return successDialog(context,
                                  "Your rescue request has been sent!!",
                                  neutralAction: () {});
                            }
                          },
                        );
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
