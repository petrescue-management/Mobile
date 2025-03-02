import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/adoption/card/pet_details.dart';

// ignore: must_be_immutable
class PetCard extends StatefulWidget {
  List<PetModel> petList;
  PetModel pet;

  PetCard({
    this.petList,
    this.pet,
  });

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
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
                pet: widget.pet,
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
                                  widget.pet.petName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                widget.pet.petGender == 1
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
                                widget.pet.petBreedName == null
                                    ? "null"
                                    : widget.pet.petBreedName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: fadedBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                widget.pet.petAge,
                                style: TextStyle(
                                  fontSize: 14,
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
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: mainColor, width: 1),
              ),
            ),
            // pet image
            Container(
              width: size.width * 0.4,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.pet.petImgUrl.first),
                        fit: BoxFit.cover,
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
