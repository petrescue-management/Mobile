import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/models/pet/adopted_pet_model.dart';
import 'package:pet_rescue_mobile/views/personal/adoptedpet/detail/pet_detail.dart';
import 'package:pet_rescue_mobile/views/personal/adoptedpet/detail/owner_detail.dart';

// ignore: must_be_immutable
class AdoptedDetails extends StatefulWidget {
  AdoptedPetModel adopted;

  AdoptedDetails({this.adopted});

  @override
  _AdoptedDetailsState createState() => _AdoptedDetailsState();
}

class _AdoptedDetailsState extends State<AdoptedDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'THÔNG TIN CHI TIẾT',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 35,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: buildTabBar(),
        ),
        body: Stack(
          children: [
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(adopted),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.65)),
          ),
            buildTabBody(),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'Philosopher',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: mainColor,
      tabs: <Widget>[
        Tab(text: 'Thú cưng'),
        Tab(text: 'Người nhận nuôi'),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: <Widget>[
      PetDetail(adopted: widget.adopted),
      OwnerDetail(adopted: widget.adopted),
    ]);
  }
}
