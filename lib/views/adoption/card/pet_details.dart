import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/views/adoption/form/adoption_form.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  PetModel pet;
  final _repo = Repository();

  DetailsScreen({this.pet});

  @override
  Widget build(BuildContext context) {
    var vaccine =
        pet.isVaccinated ? 'Đã chích ngừa vaccine' : 'Chưa chích ngừa vaccine';
    var ster = pet.isSterilized ? 'Đã triệt sản' : 'Chưa triệt sản';

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
                        pet.imgUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                //description
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            'Một số thông tin của bé: \n  Mô tả: \n   - ${pet.petDescription}\n   - Màu lông: ${pet.petFurColorName} \n  Tình trạng sức khỏe: \n   - Cân nặng: ${pet.petWeight} kg\n   - $vaccine\n   - $ster',
                            style: TextStyle(
                              color: fadedBlack,
                              height: 1.5,
                              fontSize: 15,
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
          // back button
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
          // pet info
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
                  // pet name and gender
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.petName,
                        style: TextStyle(
                          color: fadedBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        pet.petGender == 1
                            ? FontAwesomeIcons.venus
                            : FontAwesomeIcons.mars,
                        size: 18,
                        color: Colors.black54,
                      )
                    ],
                  ),
                  // pet breed and age
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.petBreedName == null ? "null" : pet.petBreedName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pet.petAge,
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
          //adopt button
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
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.all(20),
                  child: FutureBuilder<FirebaseUser>(
                    future: _repo.getCurrentUser(),
                    builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                      return CustomButton(
                        label: 'ĐĂNG KÝ NHẬN NUÔI',
                        onTap: () {
                          if (snapshot.hasError) {
                            return waitDialog(context);
                          } else if (snapshot.data == null) {
                            return infoDialog(
                              context,
                              "Bạn chưa đăng nhập vào tài khoản của bạn!",
                              neutralAction: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginRequest(
                                          pet: pet,
                                        )));
                              },
                              title: "",
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AdoptFormRegistrationPage(
                                    pet: pet,
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
