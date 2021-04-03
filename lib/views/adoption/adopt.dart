import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate_display.dart';

import 'package:pet_rescue_mobile/bloc/pet_bloc.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({Key key}) : super(key: key);

  @override
  _AdoptionPageState createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    petBloc.getListByType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nhận nuôi thú cưng',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgz6),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          StreamBuilder(
            stream: petBloc.getPetListByType,
            builder: (context, AsyncSnapshot<PetListBaseModel> snapshot) {
              if (snapshot.hasError || snapshot.data == null) {
                return loading(context);
              } else {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.result.length,
                          itemBuilder: (context, index) {
                            return petList(index, snapshot);
                          },
                        ),
                      ),
                      PetCategoryDisplay(
                          petList:
                              snapshot.data.result[selectedCategory].listPet),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // loading
  Widget loading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // pet list by name
  // ignore: missing_return
  Widget petList(int index, AsyncSnapshot<PetListBaseModel> snapshot) {
    var tmp = snapshot.data.result;

    for (var i = index; i < tmp.length; i++) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: customShadow,
                  border: selectedCategory == index
                      ? Border.all(
                          color: secondaryGreen,
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  tmp[i].typeName == 'Chó' ? iconDog : iconCat,
                  scale: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
