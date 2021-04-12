import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/models/pet/adopted_pet_model.dart';

// ignore: must_be_immutable
class PetDetail extends StatefulWidget {
  AdoptedPetModel adopted;

  PetDetail({this.adopted});

  @override
  _PetDetailState createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  ScrollController scrollController = ScrollController();

  TextEditingController breedController = TextEditingController();
  TextEditingController furController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController adoptedAtController = TextEditingController();

  List<String> imgUrlList;
  List<Widget> imageSliders;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      nameController.text = widget.adopted.petName;
      breedController.text = widget.adopted.petBreedName;
      furController.text = widget.adopted.petColorName;

      // if (widget.form.pet.petGender == 1) {
      //   genderController.text = 'Cái';
      // } else if (widget.form.pet.petGender == 2) {
      //   genderController.text = 'Đực';
      // } else {
      //   genderController.text = 'Khác';
      // }

      adoptedAtController.text = formatDateTime(widget.adopted.adoptedAt);

      imgUrlList = widget.adopted.petImgUrl;

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
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: petInfo(),
    );
  }

  petInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                }),
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
                        : Color.fromRGBO(0, 0, 0, 0.4)),
              );
            }).toList(),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.56,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                    // adopted date
                    Container(
                      child: TextFormField(
                        controller: adoptedAtController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Nhận nuôi từ ngày',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
