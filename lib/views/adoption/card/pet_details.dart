import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/views/widget/custom_button.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/views/adoption/form/adoption_dorm.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  List<PetModel> petList;
  String id;
  String petName;
  String petBreed;
  String imgUrl;
  final _repo = Repository();

  DetailsScreen({this.petList, this.id});

  @override
  Widget build(BuildContext context) {
    petList.forEach((pet) {
      if (pet.petId == id) {
        petName = pet.petName;
        petBreed = pet.petBreed;
        imgUrl = pet.imgUrl;
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                //image
                Expanded(
                  child: Container(
                    child: ClipRRect(
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                      ),
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
                        //description
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
                    icon: Icon(
                      Icons.chevron_left,
                      size: 35,
                    ),
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
              margin: EdgeInsets.symmetric(horizontal: 20),
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
                      // Icon(
                      //   gender == 'female'
                      //       ? FontAwesomeIcons.venus
                      //       : FontAwesomeIcons.mars,
                      //   size: 22,
                      //   color: Colors.black54,
                      // )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        petBreed == null ? "null" : petBreed,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   age,
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.black,
                      //   ),
                      // ),
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
                    builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                      return CustomButton(
                        label: 'Nhận nuôi',
                        onTap: () {
                          if (snapshot.hasError) {
                            return waitDialog(context);
                          } else if (snapshot.data == null) {
                            return infoDialog(
                              context,
                              "Bạn chưa đăng nhập vào tài khoản của bạn!",
                              neutralAction: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginRequest()));
                              },
                              title: "",
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AdoptFormRegistrationPage(
                                    petId: id,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
