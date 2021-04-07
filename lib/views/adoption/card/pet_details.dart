import 'package:commons/commons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/views/adoption/form/adopt_policy.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  PetModel pet;

  DetailsScreen({this.pet});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  ScrollController scrollController = ScrollController();

  TextEditingController breedController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController furController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController centerNameController = TextEditingController();
  TextEditingController centerAddressController = TextEditingController();

  final _repo = Repository();

  @override
  void initState() {
    super.initState();
    getPet();
  }

  getPet() async {
    setState(() {
      breedController.text = widget.pet.petBreedName;
      ageController.text = widget.pet.petAge;
      nameController.text = widget.pet.petName;
      furController.text = widget.pet.petFurColorName;
      descriptionController.text = widget.pet.petProfileDescription;

      centerNameController.text = widget.pet.centerName;
      centerAddressController.text = widget.pet.centerAdrress;

      if (widget.pet.petGender == 1) {
        genderController.text = 'Cái';
      } else if (widget.pet.petGender == 2) {
        genderController.text = 'Đực';
      } else {
        genderController.text = 'Khác';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'THÔNG TIN CỦA BÉ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(adopt),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          petInfo(),
          //adopt button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
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
                                          pet: widget.pet,
                                        )));
                              },
                              title: "",
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AdoptionAgreement(
                                    pet: widget.pet,
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

  petInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // image
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.24,
          child: ClipRRect(
            child: Image.network(
              widget.pet.petImgUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
          child: SizedBox(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: centerNameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Trung tâm',
                        labelStyle: TextStyle(
                          color: color2,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color2,
                            width: 2,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabled: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      controller: centerAddressController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Địa chỉ trung tâm',
                        labelStyle: TextStyle(
                          color: color2,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color2,
                            width: 2,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabled: false,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // name
                  Container(
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Tên của bé',
                        labelStyle: TextStyle(
                          color: color2,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color2,
                            width: 2,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabled: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // age and gender
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // age
                      Container(
                        width: 180,
                        child: TextFormField(
                          controller: ageController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Tuổi',
                            labelStyle: TextStyle(
                              color: color2,
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2,
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
                          ),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: TextFormField(
                          controller: genderController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Giới tính',
                            labelStyle: TextStyle(
                              color: color2,
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2,
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // breed and fur color
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // breed
                      Container(
                        width: 180,
                        child: TextFormField(
                          controller: breedController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Giống',
                            labelStyle: TextStyle(
                              color: color2,
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2,
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
                          ),
                        ),
                      ),
                      // fur color
                      Container(
                        width: 180,
                        child: TextFormField(
                          controller: furController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Màu lông',
                            labelStyle: TextStyle(
                              color: color2,
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2,
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // description
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Mô tả thêm',
                        labelStyle: TextStyle(
                          color: color2,
                          fontSize: 18,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color2,
                            width: 2,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      enabled: false,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
