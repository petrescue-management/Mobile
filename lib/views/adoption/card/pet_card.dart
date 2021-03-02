import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/views/adoption/card/pet_details.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

// ignore: must_be_immutable
class PetCard extends StatelessWidget {
  List<PetModel> petList;
  String petId;
  String petName;
  String petBreed;
  String petType;
  String age;
  //String gender;
  String imagePath;

  PetCard({
    this.petType,
    this.petList,
    this.petId,
    this.petName,
    this.petBreed,
    this.age,
    //this.gender,
    this.imagePath,
  });

  getPetAge() {
    if (age == '0') {
      if (petType == "Dog")
        return "Puppy";
      else
        return "Kitten";
    } else if (age == '1') {
      return "Adult";
    } else if (age == '2') {
      return "Senior";
    } else {
      return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = MediaQuery.of(context).size.height * 0.24;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(
                id: petId,
                petList: petList,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: cardHeight,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 70,
                bottom: 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.45,
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                petName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.venus,
                                // gender == 'female'
                                //     ? FontAwesomeIcons.venus
                                //     : FontAwesomeIcons.mars,
                                size: 18,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          Text(
                            petBreed == null ? "null" : petBreed,
                            style: TextStyle(
                              fontSize: 12,
                              color: fadedBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            getPetAge(),
                            style: TextStyle(
                              fontSize: 12,
                              color: fadedBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: customShadow,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Container(
              width: size.width * 0.45,
              child: Stack(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        height: 150,
                        width: 200,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 50),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
