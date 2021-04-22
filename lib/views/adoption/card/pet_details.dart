import 'package:commons/commons.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/adoption/form/adopt_policy.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';

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
  TextEditingController insertedAtController = TextEditingController();

  final _repo = Repository();

  List<String> imgUrlList;
  List<Widget> imageSliders;
  int _current = 0;

  @override
  void initState() {
    super.initState();
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

      insertedAtController.text = formatDateTime(widget.pet.insertedAt);

      imgUrlList = widget.pet.petImgUrl;

      imageSliders = imgUrlList
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imgUrlList.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String tmpDay = (tmp.day < 10 ? '0${tmp.day}' : '${tmp.day}');
    String tmpMonth = (tmp.month < 10 ? '0${tmp.month}' : '${tmp.month}');
    String result = '$tmpDay/$tmpMonth/${tmp.year}';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pet.petProfileId);
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
                            _repo
                                .checkExistAdoptionRegistrationForm(
                                    widget.pet.petProfileId)
                                .then((value) {
                              if (value != null) {
                                warningDialog(
                                  context,
                                  "Bạn đã đăng ký nhận nuôi bé thú cưng này. Hãy kiểm tra lại đơn đăng ký của bạn mục 'Yêu cầu của tôi'.",
                                  title: '',
                                  neutralText: 'Đóng',
                                  neutralAction: () {
                                    Navigator.pop(context);
                                  },
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
                            });
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
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgUrlList.map((url) {
            int index = imgUrlList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
          child: SizedBox(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  // name
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Tên của bé',
                        labelStyle: TextStyle(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
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
                  // center name
                  Container(
                    child: TextFormField(
                      controller: centerNameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Trung tâm quản lý',
                        labelStyle: TextStyle(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
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
                  // center address
                  Container(
                    child: TextFormField(
                      controller: centerAddressController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Địa chỉ trung tâm',
                        labelStyle: TextStyle(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
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
                  // inserted at
                  Container(
                    child: TextFormField(
                      controller: insertedAtController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Đã ở trung tâm từ ngày',
                        labelStyle: TextStyle(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
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
                        width: 170,
                        child: TextFormField(
                          controller: ageController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Tuổi',
                            labelStyle: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainColor,
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
                          ),
                        ),
                      ),
                      // gender
                      Container(
                        width: 170,
                        child: TextFormField(
                          controller: genderController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Giới tính',
                            labelStyle: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainColor,
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
                        width: 170,
                        child: TextFormField(
                          controller: breedController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Giống',
                            labelStyle: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainColor,
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
                        width: 170,
                        child: TextFormField(
                          controller: furController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Màu lông',
                            labelStyle: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainColor,
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
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
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
