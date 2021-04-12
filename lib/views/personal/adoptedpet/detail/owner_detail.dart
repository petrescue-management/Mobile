import 'package:intl/intl.dart';
import 'package:commons/commons.dart';

import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/models/pet/adopted_pet_model.dart';

import 'package:pet_rescue_mobile/src/style.dart';

// ignore: must_be_immutable
class OwnerDetail extends StatefulWidget {
  AdoptedPetModel adopted;

  OwnerDetail({this.adopted});

  @override
  _OwnerDetailState createState() => _OwnerDetailState();
}

class _OwnerDetailState extends State<OwnerDetail> {
  ScrollController scrollController = ScrollController();

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      userNameController.text = widget.adopted.username;
      emailController.text = widget.adopted.email;
      phoneController.text = widget.adopted.phone;
      jobController.text = widget.adopted.job;
      addressController.text = widget.adopted.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.0),
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ownerInfo(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  convertStringtoDateTime(String date) {
    DateTime tmp = DateFormat('yyyy-MM-dd').parse(date);
    var result = DateFormat.yMMMMd('vi_VN').format(tmp);
    return result;
  }

  Widget ownerInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
            //* USERNAME
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Họ tên',
                  labelStyle: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                      width: 2,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: false,
                  prefixIcon: Icon(
                    Icons.mail,
                    color: mainColor,
                  ),
                ),
                enabled: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //* PHONE
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Số điện thoại',
                labelStyle: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 2,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                counterText: '',
                prefixIcon: Icon(
                  Icons.phone_iphone,
                  color: mainColor,
                ),
              ),
              maxLength: 10,
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* EMAIL
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 2,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                enabled: false,
                prefixIcon: Icon(
                  Icons.mail,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* JOB
            TextFormField(
              controller: jobController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Nghề nghiệp',
                labelStyle: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 2,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                enabled: false,
                prefixIcon: Icon(
                  Icons.mail,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* ADDRESS
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Địa chỉ',
                labelStyle: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 2,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                enabled: false,
                prefixIcon: Icon(
                  Icons.mail,
                  color: mainColor,
                ),
              ),
              enabled: false,
              maxLines: 3,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
