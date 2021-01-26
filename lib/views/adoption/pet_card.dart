import 'dart:math';

import 'package:pet_rescue_mobile/views/adoption/pet_details.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class PetCard extends StatelessWidget {
  String petId;
  String petName = '';
  String breed = '';
  String age = '';
  String gender = '';
  String imagePath = '';

  PetCard({
    this.petId,
    this.petName,
    this.breed,
    this.age,
    this.gender,
    this.imagePath,
  });

  final colors = [
    Colors.blueGrey[200],
    Colors.green[200],
    Colors.pink[100],
    Colors.brown[200],
    Colors.lightBlue[200],
  ];

  Random _random = new Random();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = MediaQuery.of(context).size.height * 0.24;
    final randomColor = colors[_random.nextInt(colors.length)];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(
                id: petId,
                color: randomColor,
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
                                gender == 'female'
                                    ? FontAwesomeIcons.venus
                                    : FontAwesomeIcons.mars,
                                size: 18,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          Text(
                            breed,
                            style: TextStyle(
                              fontSize: 12,
                              color: fadedBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            age + ' years',
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
                    decoration: BoxDecoration(
                      color: randomColor,
                      boxShadow: customShadow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(top: 50),
                  ),
                  Align(
                    child: Hero(
                      tag: petId,
                      child: Image.asset(
                        imagePath,
                        height: 170,
                      ),
                    ),
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
