import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/adoption/card/pet_card.dart';

// ignore: must_be_immutable
class PetCategoryDisplay extends StatelessWidget {
  List<PetModel> petList;

  PetCategoryDisplay({this.petList});

  @override
  Widget build(BuildContext context) {
    if (petList.length == 0) {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 200),
          child: Column(
            children: [
              Image(
                image: AssetImage(emptyBox),
                height: 100,
              ),
              SizedBox(height: 15),
              Text(
                'Hiện chưa có bé nào cần tìm chủ!',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: petList.length,
          itemBuilder: (context, index) {
            return Container(
              child: PetCard(
                petList: petList,
                pet: petList[index],
              ),
            );
          },
        ),
      );
    }
  }
}
