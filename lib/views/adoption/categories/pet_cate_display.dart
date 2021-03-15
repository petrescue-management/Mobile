import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/adoption/card/pet_card.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

// ignore: must_be_immutable
class PetCategoryDisplay extends StatelessWidget {
  List<PetModel> petList;

  PetCategoryDisplay({
    this.petList
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: petList.length,
        itemBuilder: (context, index) {
          return Container(
            child: PetCard(
              petList: petList,
              petId: petList[index].petId,
              petName: petList[index].petName,
              petBreed: petList[index].petBreed,
              //age: petList[index].petAge,
              imagePath: petList[index].imgUrl,
              petType: petList[index].petTypeName,
            ),
          );
        },
      ),
    );
  }
}