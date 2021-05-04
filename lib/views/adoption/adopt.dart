import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/bloc/pet_bloc.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_type.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate_display.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';

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

  final _repo = Repository();

  String filterFurColor = '';
  String filterAge = '';
  List<String> petFurColorList = [];
  List<String> petAgeList = [
    'Nhỏ/Trẻ',
    'Vừa/Trưởng thành',
    'Lớn/Già',
    'Không xác định'
  ];

  @override
  void initState() {
    super.initState();
    petBloc.getListByType();
    _repo.getPetFurColorList().then((value) {
      if (value != null) {
        List<String> tmpResult = [];
        value.result.forEach((element) {
          tmpResult.add(element.petFurColorName);
        });

        setState(() {
          petFurColorList = tmpResult;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NHẬN NUÔI BÉ CƯNG',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 35),
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
                image: AssetImage(adopt),
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
                snapshot.data.result.forEach((element) {
                  element.listPet.sort((a, b) => a.petName.compareTo(b.petName));
                });

                return Container(
                  margin: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.result.length,
                          itemBuilder: (context, index) {
                            return petList(index, snapshot.data.result);
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

  // pet list by name
  // ignore: missing_return
  Widget petList(int index, List<PetType> resultList) {
    for (var i = index; i < resultList.length; i++) {
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
                width: 80,
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: customShadow,
                  border: selectedCategory == index
                      ? Border.all(
                          color: mainColor,
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  resultList[i].typeName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
