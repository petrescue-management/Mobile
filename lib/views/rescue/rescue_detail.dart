import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:path/path.dart';
import 'package:pet_rescue_mobile/models/image_upload.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/bloc/form_bloc.dart';
import 'package:pet_rescue_mobile/src/status.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/personal/progress/progress_report.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

// ignore: must_be_immutable
class RescueDetail extends StatefulWidget {
  Map<String, dynamic> formInput;
  double latitude, longitude;
  List<Object> imageList;
  String address = '';

  RescueDetail(
      {this.formInput,
      this.imageList,
      this.address,
      this.latitude,
      this.longitude});

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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 60),
                          child: CustomButton(
                            label: 'GỬI YÊU CẦU',
                            onTap: () {
                              if (_fbKey.currentState.saveAndValidate()) {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ProgressDialog(message: 'Đang gửi...'));

                                RescueReport tmpReport = new RescueReport();
                                tmpReport.finderDescription =
                                    widget.formInput['description'];
                                tmpReport.latitude = widget.latitude;
                                tmpReport.longitude = widget.longitude;
                                tmpReport.phone =
                                    widget.formInput['phoneNumber'];

                                if (widget.formInput['radioPetStatus'] ==
                                    'Đi lạc')
                                  tmpReport.petAttribute =
                                      PetAttribute.Lost.index + 1;
                                else if (widget.formInput['radioPetStatus'] ==
                                    'Bị bỏ rơi')
                                  tmpReport.petAttribute =
                                      PetAttribute.Abandoned.index + 1;
                                else if (widget.formInput['radioPetStatus'] ==
                                    'Bị thương')
                                  tmpReport.petAttribute =
                                      PetAttribute.Injured.index + 1;
                                else
                                  tmpReport.petAttribute =
                                      PetAttribute.Giveaway.index + 1;

                                String url = '';
                                for (var item in widget.imageList) {
                                  if (item is ImageUploadModel) {
                                    print(item.getImageFile);
                                    String baseName =
                                        basename(item.getImageFile.path);

                                    if (baseName != null) {
                                      _repo
                                          .uploadRescueImage(
                                              item.getImageFile, baseName)
                                          .then((value) {
                                        setState(() {
                                          url += '$value;';
                                          tmpReport.finderFormImgUrl = url;

                                          formBloc
                                              .createRescueRequest(tmpReport);
                                          successDialog(context,
                                              'Yêu cầu của bạn đã được gửi tới\ncác trung tâm cứu hộ.',
                                              title: 'Thành công',
                                              neutralAction: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProgressReportPage(),
                                              ),
                                            );
                                          });
                                        });
                                      });
                                    } else {
                                      print('error');
                                    }
                                  }
                                }
                              }
                            },
                          ),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: widget.imageList.length,
                  itemBuilder: (context, i) {
                    if (widget.imageList[i] is ImageUploadModel) {
                      ImageUploadModel tmpImageModel = widget.imageList[i];
                      return SizedBox(
                        child: Image.file(
                          tmpImageModel.imageFile,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Container(
                        color: Colors.white.withOpacity(0.1),
                      );
                    }
                  },
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
                      color: color2,
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
                      color: color2,
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
                      color: color2,
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
                      color: color2,
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
                      color: color2,
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
                        color: color2,
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
                    style: TextStyle(fontSize: 16, fontFamily: 'Philosopher'),
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
                      ),
                      TextSpan(
                        text: 'của tổ chức. ',
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
}
