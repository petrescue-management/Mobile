import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/adoption/card/pet_details.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

// ignore: must_be_immutable
class PetCard extends StatelessWidget {
  List<PetModel> petList;
  PetModel pet;

  PetCard({
    this.petList,
    this.pet,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = MediaQuery.of(context).size.height * 0.22;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(
                pet: pet,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        height: cardHeight,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 40,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.42,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // pet name and gender
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  pet.petName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                pet.petGender == 1
                                    ? FontAwesomeIcons.venus
                                    : FontAwesomeIcons.mars,
                                size: 18,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          // pet breed and age
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.petBreedName == null
                                    ? "null"
                                    : pet.petBreedName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: fadedBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                pet.petAge,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: fadedBlack,
                                ),
                              ),
                            ],
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
            // pet image
            Container(
              width: size.width * 0.4,
              child: Stack(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        pet.petImgUrl,
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 32),
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
