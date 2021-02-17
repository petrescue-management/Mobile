import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/style.dart';

class PetCategories extends StatefulWidget {
  PetCategories({Key key}) : super(key: key);

  @override
  _PetCategoriesState createState() => _PetCategoriesState();
}

class _PetCategoriesState extends State<PetCategories> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
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
                      categories[index]['iconPath'],
                      scale: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
