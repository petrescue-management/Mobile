import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';

import 'package:pet_rescue_mobile/views/personal/progress/adopt_registration/detail/pet_detail.dart';
import 'package:pet_rescue_mobile/views/personal/progress/adopt_registration/detail/register_detail.dart';

// ignore: must_be_immutable
class AdoptFormDetails extends StatefulWidget {
  AdoptionRegisForm form;

  AdoptFormDetails({this.form});

  @override
  _AdoptFormDetailsState createState() => _AdoptFormDetailsState();
}

class _AdoptFormDetailsState extends State<AdoptFormDetails> {
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
            Container(color: backgroundColor),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
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
        fontFamily: 'SamsungSans',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: mainColor,
      tabs: <Widget>[
        Tab(text: 'Thú cưng'),
        Tab(text: 'Người đăng ký'),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: <Widget>[
      PetDetails(form: widget.form),
      RegisterDetail(form: widget.form)
    ]);
  }
}
