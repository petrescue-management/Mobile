import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:commons/commons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/user/user_model.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import '../../../main.dart';

// ignore: must_be_immutable
class ProfileDetails extends StatefulWidget {
  UserModel user;

  ProfileDetails({this.user});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ScrollController scrollController = ScrollController();

  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController tmpDateController = TextEditingController();

  final _repo = Repository();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      lastNameController.text = widget.user.lastName;
      firstNameController.text = widget.user.firstName;
      emailController.text = widget.user.email;
      phoneController.text = widget.user.phone;
      dobController.text = widget.user.dob;

      tmpDateController.text = formatDateTime(dobController.text);
    });
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year}';
    return result;
  }

  File _image;

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
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
      child: WillPopScope(
        onWillPop: () {
          return confirmationDialog(context, "Hủy chỉnh sửa thông tin ?",
              positiveText: "Có",
              neutralText: "Không",
              confirm: false,
              title: "", positiveAction: () {
            Navigator.of(context).pop();
          });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              'CHỈNH SỬA THÔNG TIN',
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
                confirmationDialog(context, "Hủy chỉnh sửa thông tin ?",
                    positiveText: "Có",
                    neutralText: "Không",
                    confirm: false,
                    title: "", positiveAction: () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bglpc),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    profilePic(context, widget.user),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        right: 20,
                        left: 20,
                      ),
                      child: CustomDivider(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: profileInfo(context),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _btnSubmitInformation(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _btnSubmitInformation(context) {
    return CustomButton(
      label: 'LƯU CHỈNH SỬA',
      onTap: () {
        confirmationDialog(context, 'Bạn muốn lưu thông tin chỉnh sửa?',
            title: '',
            confirm: false,
            neutralText: 'Không',
            positiveText: 'Có', positiveAction: () {
          showDialog(
              context: context,
              builder: (context) => ProgressDialog(message: 'Đang gửi...'));

          UserModel tmpUser = new UserModel();
          tmpUser.id = widget.user.id;
          tmpUser.lastName = lastNameController.text;
          tmpUser.firstName = firstNameController.text;
          tmpUser.email = emailController.text;
          tmpUser.phone = phoneController.text;
          tmpUser.gender = widget.user.gender;
          tmpUser.dob = dobController.text;

          if (_image == null) {
            tmpUser.imgUrl = widget.user.imgUrl;

            _repo.updateUserDetails(tmpUser).then((value) {
              if (value != null) {
                successDialog(context, 'Đã cập nhật thông tin cá nhân',
                    title: 'Thành công', neutralAction: () {
                  _repo.getUserDetails();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                });
              } else {
                warningDialog(
                  context,
                  'Không thể cập nhật thông tin.',
                  title: '',
                  neutralText: 'Đóng',
                  neutralAction: () {
                    Navigator.pop(context);
                  },
                );
              }
            });
          } else {
            String url = '';
            String baseName = basename(_image.path);
            if (baseName != null) {
              _repo.uploadAvatar(_image, baseName).then((value) {
                setState(() {
                  url = value;
                  tmpUser.imgUrl = url;

                  _repo.updateUserDetails(tmpUser).then((value) {
                    if (value != null) {
                      successDialog(context, 'Đã cập nhật thông tin cá nhân',
                          title: 'Thành công',
                          neutralText: 'Quay về trang chủ', neutralAction: () {
                        _repo.getUserDetails();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      });
                    } else {
                      warningDialog(
                        context,
                        'Không thể cập nhật thông tin.',
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
          }
        });
      },
    );
  }

  Widget profilePic(BuildContext context, UserModel user) {
    var height = MediaQuery.of(context).size.height * 0.2;
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
                    ? NetworkImage(user.imgUrl)
                    : FileImage(_image),
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

  convertStringtoDateTime(String date) {
    DateTime tmp = DateFormat('yyyy-MM-dd').parse(date);
    var result = DateFormat.yMMMMd('vi_VN').format(tmp);
    return result;
  }

  Future _selectDate(context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1950),
      lastDate: new DateTime(2050),
    );
    if (picked != null)
      setState(() {
        dobController.text = picked.toString();
        tmpDateController.text = formatDateTime(dobController.text);
      });
  }

  Widget profileInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
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
                  width: 165,
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Họ',
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
                        Icons.edit_outlined,
                        color: mainColor,
                      ),
                    ),
                    maxLength: 10,
                  ),
                ),
                //* FIRSTNAME
                Container(
                  width: 165,
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Tên',
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
                        Icons.edit_outlined,
                        color: mainColor,
                      ),
                    ),
                    maxLength: 10,
                  ),
                ),
              ],
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
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            SizedBox(
              height: 20,
            ),
            //* DATE OF BIRTH
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: IgnorePointer(
                child: TextFormField(
                  controller: tmpDateController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ngày sinh*',
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
                      Icons.calendar_today,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
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
