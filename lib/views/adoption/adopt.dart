import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate.dart';
import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate_display.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({Key key}) : super(key: key);

  @override
  _AdoptionPageState createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt', style: TextStyle(color: Colors.black)),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            //PetCategories(),
            PetCategoryDisplay(),
          ],
        ),
      ),
    );
  }
}
