import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/adoption/pet_card.dart';
import 'package:pet_rescue_mobile/src/data.dart';

class PetCategoryDisplay extends StatelessWidget {
  const PetCategoryDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: dogs.length,
        itemBuilder: (context, index) {
          return Container(
            child: PetCard(
              petId: dogs[index]['id'],
              petName: dogs[index]['name'],
              age: dogs[index]['age'],
              breed: dogs[index]['breed'],
              gender: dogs[index]['gender'],
              imagePath: dogs[index]['imagePath'],
            ),
          );
        },
      ),
    );
  }
}