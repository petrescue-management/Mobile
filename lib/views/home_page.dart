import 'package:flutter/material.dart';
import 'package:commons/commons.dart';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/rescue/map/rescue_location.dart';
import 'package:pet_rescue_mobile/views/adoption/adopt.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repo = Repository();
  int _current = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imgList.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader,
          SizedBox(
            height: 20,
          ),
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                autoPlay: true,
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
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
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
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //* RESCUE BUTTON
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: FutureBuilder<FirebaseUser>(
                    future: _repo.getCurrentUser(),
                    builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                      return RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: color2,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        onPressed: () {
                          if (snapshot.hasError)
                            return waitDialog(context);
                          else if (snapshot.data == null) {
                            return infoDialog(
                              context,
                              "Hãy đăng nhập vào tài khoản của bạn",
                              neutralAction: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginRequest()));
                                // Navigator.pushNamed(
                                //     context, LoginRequest.idScreen);
                              },
                            );
                          } else
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return RescueLocation();
                                },
                              ),
                            );
                        },
                        icon: Image(
                          image: AssetImage(rescue_logo),
                          height: 30.0,
                        ),
                        label: Text(
                          ' Cứu hộ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              letterSpacing: 1.2),
                        ),
                        splashColor: Colors.red[100],
                        color: Colors.white,
                      );
                    },
                  ),
                ),
                //* ---------------------------------
                //* ADOPT PICKER
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: color2,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AdoptionPage();
                          },
                        ),
                      );
                    },
                    icon: Image(
                      image: AssetImage(adopt_logo),
                      height: 30.0,
                    ),
                    label: Text(
                      ' Nhận nuôi',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                    splashColor: Colors.red[100],
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map(
      (item) => Container(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: Stack(
              children: <Widget>[
                Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: 1500.0,
                ),
              ],
            ),
          ),
        ),
      ),
    )
    .toList();

Widget _buildHeader = Container(
  height: 250,
  width: double.infinity,
  child: Stack(
    children: <Widget>[
      Positioned(
        bottom: 0,
        left: -90,
        top: -170,
        child: Container(
          width: 350,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [color1, color2]),
              boxShadow: [
                BoxShadow(
                  color: color2,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 10.0,
                )
              ]),
        ),
      ),
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [color3, color2]),
          boxShadow: [
            BoxShadow(
              color: color3,
              offset: Offset(1.0, 1.0),
              blurRadius: 4.0,
            )
          ],
        ),
      ),
      Positioned(
        top: 100,
        right: 200,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [color3, color2]),
            boxShadow: [
              BoxShadow(
                color: color3,
                offset: Offset(1.0, 1.0),
                blurRadius: 5.0,
              )
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 50, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Welcome to",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "RESCUE THEM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 3.0,
              ),
            )
          ],
        ),
      )
    ],
  ),
);
