import 'package:pet_rescue_mobile/views/adoption/pet_details.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class PetCard extends StatelessWidget {
  String petId = '';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = MediaQuery.of(context).size.height * 0.24;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(id: petId);
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
                          // Text(
                          //   breed,
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: fadedBlack,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          Text(
                            age,
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
                        'https://st3.idealista.it/cms/archivie/2019-02/media/image/pets%203%20flickr.jpg?fv=P9PHE6uf',
                        fit: BoxFit.cover,
                        height: 150,
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
