import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate_display.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/bloc/pet_bloc.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_model.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/style.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({Key key}) : super(key: key);

  @override
  _AdoptionPageState createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  List<PetModel> petListByCategory;

  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    petBloc.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nhận nuôi thú cưng',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: petBloc.getPetList,
        builder: (context, AsyncSnapshot<PetListModel> snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
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
                ),
                PetCategoryDisplay(petList: snapshot.data.getResult),
              ],
            ));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
