import 'dart:io';
import 'package:path/path.dart';
import 'package:commons/commons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

import 'package:pet_rescue_mobile/src/enum.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/video/custom_video_player.dart';
import '../../main.dart';

// ignore: must_be_immutable
class RescueDetail extends StatefulWidget {
  Map<String, dynamic> formInput;
  double latitude, longitude;
  List<Asset> imageList;
  String address = '';
  File video;

  RescueDetail({
    this.formInput,
    this.imageList,
    this.address,
    this.latitude,
    this.longitude,
    this.video,
  });

  @override
  _RescueDetailState createState() => _RescueDetailState();
}

class _RescueDetailState extends State<RescueDetail> {
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  final _repo = Repository();

  @override
  Widget build(BuildContext context) {
    var contextHeight = MediaQuery.of(context).size.height;
    var contextWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'YÊU CẦU CỨU HỘ',
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
      body: Stack(children: [
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
            )),
      ]),
    );
  }

  _btnSubmitFinderForm(context) {
    return CustomButton(
      label: 'GỬI YÊU CẦU',
      onTap: () {
        if (_fbKey.currentState.saveAndValidate()) {
          showDialog(
              context: context,
              builder: (context) => ProgressDialog(message: 'Đang gửi...'));

          RescueReport tmpReport = new RescueReport();
          tmpReport.finderDescription = widget.formInput['description'];
          tmpReport.latitude = widget.latitude;
          tmpReport.longitude = widget.longitude;
          tmpReport.phone = widget.formInput['phoneNumber'];

          if (widget.formInput['radioPetStatus'] == 'Đi lạc')
            tmpReport.petAttribute = PetAttribute.Lost.index + 1;
          else if (widget.formInput['radioPetStatus'] == 'Bị bỏ rơi')
            tmpReport.petAttribute = PetAttribute.Abandoned.index + 1;
          else if (widget.formInput['radioPetStatus'] == 'Bị thương')
            tmpReport.petAttribute = PetAttribute.Injured.index + 1;
          else
            tmpReport.petAttribute = PetAttribute.Giveaway.index + 1;

          String url = '';
          int count = 0;
          widget.imageList.forEach((item) {
            Asset asset = item;

            _repo.getImageFileFromAssets(asset).then((result) {
              String baseName = basename(result.path);
              _repo.uploadRescueImage(result, baseName).then((value) {
                if (value != null) {
                  setState(() {
                    url += '$value;';
                    count++;
                  });

                  if (count == widget.imageList.length) {
                    tmpReport.finderFormImgUrl = url;

                    if (widget.video == null) {
                      setState(() {
                        tmpReport.finderFormVideoUrl = '';
                      });
                      _repo.createRescueRequest(tmpReport).then((value) {
                        if (value != null) {
                          successDialog(
                            context,
                            'Yêu cầu của bạn đã được gửi tới các trung tâm cứu hộ.',
                            title: 'Thành công',
                            neutralText: 'Quay về trang chủ',
                            neutralAction: () {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp(),
                                ),
                              );
                            },
                          );
                        } else {
                          warningDialog(
                            context,
                            'Không thể gửi yêu cầu cứu hộ.',
                            title: '',
                            neutralText: 'Đóng',
                            neutralAction: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      });
                    } else {
                      String vidBaseName = basename(widget.video.path);
                      _repo
                          .uploadRescueVideo(widget.video, vidBaseName)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            tmpReport.finderFormVideoUrl = value;
                          });
                          _repo.createRescueRequest(tmpReport).then((value) {
                            if (value != null) {
                              successDialog(
                                context,
                                'Yêu cầu của bạn đã được gửi tới các trung tâm cứu hộ.',
                                title: 'Thành công',
                                neutralText: 'Đóng',
                                neutralAction: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyApp(),
                                    ),
                                  );
                                },
                              );
                            } else {
                              warningDialog(
                                context,
                                'Không thể gửi yêu cầu cứu hộ.',
                                title: '',
                                neutralText: 'Đóng',
                                neutralAction: () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          });
                        } else {
                          warningDialog(
                            context,
                            'Lỗi upload video.',
                            title: '',
                            neutralText: 'Đóng',
                            neutralAction: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      });
                    }
                  }
                } else {
                  warningDialog(
                    context,
                    'Lỗi upload hình ảnh.',
                    title: '',
                    neutralText: 'Đóng',
                    neutralAction: () {
                      Navigator.pop(context);
                    },
                  );
                }
              });
            });
          });
        }
      },
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
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  ' Ảnh mô tả',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  children: List.generate(
                    widget.imageList.length,
                    (index) {
                      Asset asset = widget.imageList[index];
                      return AssetThumb(
                        asset: asset,
                        width: 300,
                        height: 300,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              //* VIDEO PICKER
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' Video mô tả',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3),
              widget.video == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Không có video mô tả',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )
                  : Center(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: VideoThumbnail(
                          video: widget.video,
                        ),
                      ),
                    ),
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
                    hintText: widget.formInput['phoneNumber'],
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
                    hintText: widget.formInput['radioPetStatus'],
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
              SizedBox(height: 10),
              //* DESCRIPTION
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả thêm',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.formInput['description'],
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
              //* CONFIRMATION
              FormBuilderCheckbox(
                attribute: 'acceptTerms',
                onChanged: (value) => () {
                  var _onChanged = true;
                  setState(() {
                    value = _onChanged;
                    _onChanged = !_onChanged;
                  });
                },
                initialValue: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                label: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, fontFamily: 'SamsungSans'),
                    children: [
                      TextSpan(
                        text: '* ',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text: 'Tôi đã đọc và đồng ý với ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                          text: 'Điều khoản và Điều kiện ',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      buildPolicyDialog(context));
                            }),
                      TextSpan(
                        text: 'của hệ thống. ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                validators: [
                  FormBuilderValidators.requiredTrue(
                      errorText:
                          'Bạn cần đồng ý với điều khoản của chúng tôi.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPolicyDialog(context) {
    return AlertDialog(
      title: const Text(
        'Điều khoản',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: mainColor,
          child: Text(
            'Đã hiểu',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return RichText(
      text: TextSpan(
        text: 'Khi gửi yêu cầu cứu hộ, bạn cần lưu ý các điều sau đây:\n\n',
        style: TextStyle(color: Colors.black87, fontSize: 18, height: 1.3),
        children: <TextSpan>[
          TextSpan(
              text:
                  '- Sau khi nhấn gửi, yêu cầu sẽ được thông báo đến tình nguyện viên thuộc 2 trung tâm gần nhất.\n'),
          TextSpan(
              text:
                  '- Trong trường hợp sau một khoảng thời gian nhất định, nếu không có tình nguyện viên nào thuộc 2 trung tâm đó nhận yêu cầu, chúng tôi sẽ tiếp tục gửi thông báo cho tất cả tình nguyện viên.\n'),
          TextSpan(
              text:
                  '- Sau 24 giờ, nếu yêu cầu của bạn vẫn chưa được xử lý, yêu cầu sẽ tự động hủy.'),
        ],
      ),
    );
  }
}
