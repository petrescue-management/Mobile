import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate.dart';
import 'package:pet_rescue_mobile/views/adoption/categories/pet_cate_display.dart';

import 'package:pet_rescue_mobile/bloc/pet_bloc.dart';
import 'package:pet_rescue_mobile/models/pet/pet_list_model.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({Key key}) : super(key: key);

  @override
  _AdoptionPageState createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

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
                //PetCategories(),
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
