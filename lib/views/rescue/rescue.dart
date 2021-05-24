import 'dart:io';
import 'package:commons/commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/custom_widget/video/custom_video_player.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue_detail.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue_location.dart';

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

  final _repo = Repository();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  List<Asset> _images = List<Asset>();
  int limitImg;
  bool hasImage = false;

  File video;
  bool hasVideo = false;

  @override
  void initState() {
    _repo.getNumberOfImage().then((value) {
      if (value != null) {
        print('not null: ${value.imageForFinder}');
        setState(() {
          limitImg = value.imageForFinder;
        });
      } else {
        setState(() {
          limitImg = 3;
        });
      }
    });

    super.initState();
  }

  Widget buildViewPickedImages() {
    if (_images.length == 0 || hasImage == false)
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 1,
        children: List.generate(3, (index) {
          return Card(
            child: Icon(
              Icons.image,
              color: Colors.grey,
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
                      });

                      if (_images.length == 0) {
                        setState(() {
                          hasImage = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      );
  }

  Widget buildViewPickedVideo() {
    return Stack(children: [
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: video == null
              ? Card(
                  child: Icon(
                    Icons.videocam,
                    color: Colors.grey,
                  ),
                )
              : VideoThumbnail(video: video),
        ),
      ),
      video == null
          ? SizedBox(height: 0)
          : Positioned(
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
                    video = null;
                    hasVideo = false;
                  });
                },
              ),
            ),
    ]);
  }

  pickImages() async {
    List<Object> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: limitImg,
        enableCamera: true,
        selectedAssets: _images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Chọn hình ảnh ",
        ),
      );
    } on Exception catch (e) {
      print(e);
      hasImage = false;
    }

    setState(() {
      _images = resultList;
    });

    if (_images.length > 0) {
      setState(() {
        hasImage = true;
      });
    }
  }

  captureVideo() async {
    // ignore: deprecated_member_use
    File vid = await ImagePicker.pickVideo(
        source: ImageSource.camera, maxDuration: Duration(minutes: 1));

    if (vid != null) {
      setState(() {
        video = vid;
        hasVideo = true;
      });
    }
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
                  video: hasVideo == true ? video : null,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RescueLocation(
                    latitude: 0,
                    longitude: 0,
                  ),
                ),
              );
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
                          style: TextStyle(fontFamily: 'SamsungSans'),
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
                          ' Ảnh mô tả *',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          color: Colors.blue[400],
                          textColor: Colors.white,
                          splashColor: Colors.grey,
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
              //* VIDEO PICKER
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: primaryGreen,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ' Video mô tả',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Quay video"),
                          color: Colors.blue[400],
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                          onPressed: () {
                            captureVideo();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    buildViewPickedVideo(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //* PHONE NUMBER
              Container(
                child: FormBuilderTextField(
                  attribute: 'phoneNumber',
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại *',
                    labelStyle: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
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
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy nhập số điện thoại của bạn'),
                    FormBuilderValidators.minLength(10,
                        errorText: 'Số điện thoại của bạn chưa đúng'),
                  ],
                  maxLengthEnforced: true,
                  maxLength: 10,
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
                    FormBuilderFieldOption(
                      value: 'Bị thương',
                    ),
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
                    labelText: 'Hãy mô tả thêm*',
                    labelStyle: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
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
                  maxLength: 1000,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}