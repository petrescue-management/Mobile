import 'dart:io';
import 'package:path/path.dart';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_rescue_mobile/bloc/account_bloc.dart';

import 'package:pet_rescue_mobile/models/center/center_model.dart';
import 'package:pet_rescue_mobile/models/user/volunteer_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';

import '../../../main.dart';

// ignore: must_be_immutable
class VolunteerForm extends StatefulWidget {
  CenterModel center;

  VolunteerForm({
    this.center,
  });

  @override
  _VolunteerFormState createState() => _VolunteerFormState();
}

class _VolunteerFormState extends State<VolunteerForm> {
  ScrollController scrollController = new ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  final _repo = Repository();

  File _image;

  bool hasImage = false;

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        _image = image;
        hasImage = true;
      });
    }
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      setState(() {
        _image = image;
        hasImage = true;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _btnSubmitInformation(bool hasImage, context) {
    if (hasImage == true) {
      return CustomButton(
        label: 'GỬI ĐƠN ĐĂNG KÝ',
        onTap: () {
          if (_fbKey.currentState.saveAndValidate()) {
            confirmationDialog(
              context,
              'Bạn muốn gửi đơn đăng ký tình nguyện viên?',
              title: '',
              confirm: false,
              negativeText: 'Không',
              positiveText: 'Có',
              positiveAction: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ProgressDialog(message: 'Đang gửi...'));

                final formInputs = _fbKey.currentState.value;
                print(formInputs);

                VolunteerModel user = new VolunteerModel();
                if (formInputs['radioGender'] == 'Nữ') {
                  user.gender = 1;
                } else if (formInputs['radioGender'] == 'Nam') {
                  user.gender = 2;
                } else {
                  user.gender = 3;
                }

                user.firstName = formInputs['firstName'];
                user.lastName = formInputs['lastName'];
                user.dob = formInputs['dob'].toString();
                user.phone = formInputs['phoneNumber'];
                user.email = formInputs['email'];

                user.centerId = widget.center.centerId;

                String url = '';
                String baseName = basename(_image.path);
                if (baseName != null) {
                  _repo.uploadVolunteer(_image, baseName).then((value) {
                    setState(() {
                      url = value;
                      user.imgUrl = url;

                      accountBloc.regisVolunteer(user);
                      successDialog(context,
                          'Đơn đăng ký của bạn đã được gửi đến ${widget.center.centerName.trim()}. Trung tâm sẽ xem xét và phản hồi cho bạn qua email ${user.email}. Xin cảm ơn.',
                          title: 'Thành công', neutralAction: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      });
                    });
                  });
                }
              },
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
        label: 'GỬI ĐƠN ĐĂNG KÝ',
      );
    }
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
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(volunteer),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                profilePic(context),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 40,
                    left: 40,
                  ),
                  child: CustomDivider(),
                ),
                FormBuilder(
                  key: _fbKey,
                  child: Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _volunteerRegistrationForm(context),
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 35,
                    ),
                    onPressed: () {
                      confirmationDialog(context, "Bạn muốn hủy đơn đăng ký?",
                          positiveText: "Có",
                          neutralText: "Không",
                          confirm: false,
                          title: "", positiveAction: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget profilePic(context) {
    var height = MediaQuery.of(context).size.height * 0.25;
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: mainColor, width: 2),
              image: DecorationImage(
                image: _image == null
                    ? AssetImage(
                        iconUpload,
                      )
                    : FileImage(
                        _image,
                      ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.camera,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _volunteerRegistrationForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              //* EMAIL
              Container(
                margin: EdgeInsets.only(top: 20),
                child: FormBuilderTextField(
                  attribute: 'email',
                  decoration: InputDecoration(
                    labelText: 'Email*',
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
                    prefixIcon: Icon(
                      Icons.mail,
                      color: primaryGreen,
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy nhập email của bạn.'),
                  ],
                  maxLength: 100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* LASTNAME
                  Container(
                    width: 160,
                    child: FormBuilderTextField(
                      attribute: 'lastName',
                      decoration: InputDecoration(
                        labelText: 'Họ*',
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
                        prefixIcon: Icon(
                          Icons.edit_outlined,
                          color: primaryGreen,
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: 'Hãy nhập họ của bạn'),
                      ],
                      maxLength: 20,
                    ),
                  ),
                  //* FIRSTNAME
                  Container(
                    width: 160,
                    child: FormBuilderTextField(
                      attribute: 'firstName',
                      decoration: InputDecoration(
                        labelText: 'Tên*',
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
                        prefixIcon: Icon(
                          Icons.edit_outlined,
                          color: primaryGreen,
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: 'Hãy nhập tên của bạn.'),
                      ],
                      maxLength: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //* PHONE NUMBER
              Container(
                child: FormBuilderPhoneField(
                  attribute: 'phoneNumber',
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại*',
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
                  'Giới tính*',
                  'radioGender',
                  'Bạn chưa chọn giới tính',
                  [
                    FormBuilderFieldOption(value: 'Nữ'),
                    FormBuilderFieldOption(value: 'Nam'),
                    FormBuilderFieldOption(value: 'Khác'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              //* DATE OF BIRTH
              Container(
                child: FormBuilderDateTimePicker(
                  attribute: 'dob',
                  inputType: InputType.date,
                  format: DateFormat('dd/MM/yyyy'),
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh*',
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
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: primaryGreen,
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Hãy chọn ngày sinh của bạn.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
