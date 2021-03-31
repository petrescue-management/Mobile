import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:commons/commons.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue_detail.dart';

// import 'package:intl/intl.dart';
// import 'package:pet_rescue_mobile/models/example/temp.dart';
// import 'package:pet_rescue_mobile/models/example/temp_data.dart';

// ignore: must_be_immutable
class Rescue extends StatefulWidget {
  double latitude, longitude;
  String address = '';

  Rescue({this.latitude, this.longitude, this.address});

  @override
  _RescueState createState() => _RescueState();
}

class _RescueState extends State<Rescue> {
  ScrollController scrollController = ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  final _repo = Repository();

  @override
  Widget build(BuildContext context) {
    var contextHeight = MediaQuery.of(context).size.height;
    var contextWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'YÊU CẦU CỨU HỘ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                                color: color2,
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
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomButton(
                                  label: 'XÁC NHẬN THÔNG TIN',
                                  onTap: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      final formInputs =
                                          _fbKey.currentState.value;
                                      print(formInputs);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RescueDetail(
                                            formInput: formInputs,
                                            address: widget.address,
                                            imageList: _imageList,
                                            longitude: widget.longitude,
                                            latitude: widget.latitude,
                                          ),
                                        ),
                                      );
                                    } else {
                                      warningDialog(
                                        context,
                                        'Bạn chưa điền đầy đủ thông tin.\nXin hãy kiểm tra lại.',
                                        title: '',
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
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
      ),
    );
  }

  List _imageList;
  Widget _rescueForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              //* PHONE NUMBER
              Container(
                margin: EdgeInsets.only(top: 20),
                child: FormBuilderPhoneField(
                  attribute: 'phoneNumber',
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại *',
                    labelStyle: TextStyle(
                      color: color2,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color2,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: color2,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  defaultSelectedCountryIsoCode: 'vn',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy nhập số điện thoại của bạn'),
                  ],
                  maxLengthEnforced: true,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10),
              //* IMAGE PICKER
              Container(
                alignment: Alignment.center,
                child: FormBuilderImagePicker(
                  decoration: InputDecoration(
                    labelText: 'Chọn ảnh * (Tối đa 3 hình)',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: color2,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  attribute: 'imagePicker',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bạn chưa upload ảnh !"),
                  ],
                  initialValue: _imageList,
                  valueTransformer: (value) {
                    return jsonEncode(_imageList.toString());
                  },
                  onChanged: (value) => {
                    value.forEach((item) {
                      File file = new File(item.path.toString());
                      List tmp = [];
                      _repo
                          .uploadAvatar(file, basename(file.path.toString()))
                          .then((value) {
                        setState(() {
                          tmp.add(value);
                          _imageList = tmp;
                        });
                      });
                    }),
                  },
                  maxImages: 3,
                ),
              ),
              SizedBox(height: 20),
              //* RADIO
              Container(
                child: customRadioGroup(
                  'Tình trạng của vật nuôi *',
                  'radioPetStatus',
                  'Bạn chưa chọn tình trạng của vật nuôi',
                  [
                    FormBuilderFieldOption(value: 'Đi lạc'),
                    FormBuilderFieldOption(value: 'Bị bỏ rơi'),
                    FormBuilderFieldOption(value: 'Bị thương'),
                    FormBuilderFieldOption(value: 'Cho đi'),
                    FormBuilderFieldOption(value: 'Trả về'),
                  ],
                ),
              ),
              //* DESCRIPTION
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: FormBuilderTextField(
                  attribute: 'description',
                  decoration: InputDecoration(
                    labelText: 'Hãy mô tả thêm',
                    labelStyle: TextStyle(
                      color: color2,
                    ),
                    hintText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color2,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy thêm mô tả về tình trạng của bé.'),
                  ],
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
