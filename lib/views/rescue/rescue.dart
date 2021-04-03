import 'package:commons/commons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue_detail.dart';

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

  List<Asset> _images = List<Asset>();

  bool hasImage = false;

  @override
  void initState() {
    super.initState();
  }

  Widget buildViewPickedImages() {
    if (_images.length == 0)
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 1,
        children: List.generate(3, (index) {
          return Card(
            child: IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          );
        }),
      );
    else
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: List.generate(_images.length, (index) {
          Asset asset = _images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        _images.remove(asset);
                        hasImage = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      );
  }

  pickImages() async {
    List<Object> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: _images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Chọn hình ảnh ",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      _images = resultList;
      hasImage = true;
    });
  }

  _btnSubmitInformation(bool hasImage, BuildContext context) {
    if (hasImage == true) {
      return CustomButton(
        label: 'XÁC NHẬN THÔNG TIN',
        onTap: () {
          if (_fbKey.currentState.saveAndValidate()) {
            final formInputs = _fbKey.currentState.value;

            print(formInputs);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RescueDetail(
                  formInput: formInputs,
                  address: widget.address,
                  imageList: _images,
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
      );
    } else {
      return CustomDisableButton(
        label: 'XÁC NHẬN THÔNG TIN',
      );
    }
  }

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
                                _btnSubmitInformation(hasImage, context),
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
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ' Ảnh mô tả*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Chọn ảnh"),
                          onPressed: pickImages,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    buildViewPickedImages(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //* PHONE NUMBER
              Container(
                child: FormBuilderPhoneField(
                  attribute: 'phoneNumber',
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại *',
                    labelStyle: TextStyle(
                      color: primaryGreen,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryGreen,
                        width: 1.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryGreen,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: primaryGreen,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    counterText: '',
                  ),
                  defaultSelectedCountryIsoCode: 'vn',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy nhập số điện thoại của bạn'),
                  ],
                  maxLengthEnforced: true,
                  maxLength: 9,
                  keyboardType: TextInputType.number,
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
                    FormBuilderFieldOption(value: 'Bị thương'),
                    FormBuilderFieldOption(value: 'Đi lạc'),
                    FormBuilderFieldOption(value: 'Bị bỏ rơi'),
                    FormBuilderFieldOption(value: 'Cho đi'),
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
                      color: primaryGreen,
                    ),
                    hintText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryGreen,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    counterText: '',
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy thêm mô tả về tình trạng của bé.'),
                  ],
                  maxLines: 6,
                  maxLength: 250,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
