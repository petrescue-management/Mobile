import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/views/rescue.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Widget homePageAppBar = AppBar(
    backgroundColor: Colors.white,
    title: Text(
      'RESCUE THEM',
      style: TextStyle(
        color: Colors.black,
      ),
    ),
    automaticallyImplyLeading: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageAppBar,
      body: Column(children: [
        SizedBox(
          height: 25,
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
        SizedBox(
          height: 50,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.65,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return RescueForm();
                  },
                ),
              );
            },
            icon: Image(image: AssetImage(rescue_logo), height: 30.0),
            label: Text(
              ' Rescue',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            textColor: Colors.white,
            splashColor: Colors.red,
            color: Colors.green,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.65,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            onPressed: () {
              print('Button Clicked.');
            },
            icon: Image(image: AssetImage(adopt_logo), height: 30.0),
            label: Text(
              ' Adoption',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            textColor: Colors.white,
            splashColor: Colors.red,
            color: Colors.blue,
          ),
        ),
      ]),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1500.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
