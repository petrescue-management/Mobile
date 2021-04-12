import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';

import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';

import '../../../../main.dart';

// ignore: must_be_immutable
class FinderCardDetail extends StatefulWidget {
  FinderForm finder;
  String address;

  FinderCardDetail({
    this.finder,
    this.address,
  });

  @override
  _FinderCardDetailState createState() => _FinderCardDetailState();
}

class _FinderCardDetailState extends State<FinderCardDetail> {
  ScrollController scrollController = ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  final _repo = Repository();

  String petAttribute;

  getPetAttribute(int petAttribute) {
    if (petAttribute == 1)
      return 'Đi lạc';
    else if (petAttribute == 2)
      return 'Bị bỏ rơi';
    else if (petAttribute == 3)
      return 'Bị thương';
    else
      return 'Cho đi';
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      petAttribute = getPetAttribute(widget.finder.petAttribute);
    });
  }

  @override
  Widget build(BuildContext context) {
    var contextHeight = MediaQuery.of(context).size.height;
    var contextWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'CHI TIẾT CỨU HỘ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgp8),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Container(
            height: contextHeight,
            width: contextWidth,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontFamily: 'Philosopher'),
                        children: [
                          TextSpan(
                            text: 'Địa chỉ của bạn:\n',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 16,
                              height: 2,
                            ),
                          ),
                          TextSpan(
                              text: (widget.address != null ||
                                      widget.address != '')
                                  ? '${widget.address}'
                                  : 'Chưa cập nhật địa chỉ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 30,
                    left: 30,
                  ),
                  child: CustomDivider(),
                ),
                FormBuilder(
                  key: _fbKey,
                  child: Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _rescueForm(context),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 60,
                          ),
                          child: _btnSubmitFinderForm(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _btnSubmitFinderForm(context) {
    if (widget.finder.finderFormStatus == 1) {
      return CustomButton(
        label: 'HỦY YÊU CẦU',
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ProgressDialog(message: 'Đang hủy...'),
          );

          _repo.cancelFinderForm(widget.finder.finderFormId).then((value) {
            if (value == null) {
              warningDialog(
                context,
                'Không thể hủy yêu cầu.',
                title: '',
                neutralText: 'Đóng',
                neutralAction: () {
                  Navigator.pop(context);
                },
              );
            } else {
              successDialog(
                context,
                'Yêu cầu của bạn đã được gửi tới các trung tâm cứu hộ.',
                title: 'Thành công',
                neutralText: 'Đóng',
                neutralAction: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
              );
            }
          });
        },
      );
    } else if (widget.finder.finderFormStatus == 2 ||
        widget.finder.finderFormStatus == 3) {
      return CustomDisableButton(
        label: 'HỦY YÊU CẦU',
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget _rescueForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              //* IMAGE PICKER
              Container(
                  margin: EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: GridView.builder(
                    itemCount: widget.finder.finderImageUrl.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemBuilder: (context, int index) {
                      String item = widget.finder.finderImageUrl[index];
                      return Image.network(
                        item,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
              SizedBox(height: 10),
              //* PHONE NUMBER
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.phone,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 10),
              //* RADIO
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Tình trạng của thú cưng',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: petAttribute,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.pets,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //* DESCRIPTION
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả thêm',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.finderDescription,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  ),
                  enabled: false,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
