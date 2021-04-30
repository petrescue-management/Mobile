import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:commons/commons.dart';

import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/personal/progress/progress_report.dart';

import '../../../../../main.dart';

// ignore: must_be_immutable
class RegisterDetail extends StatefulWidget {
  AdoptionRegisForm form;

  RegisterDetail({this.form});

  @override
  _RegisterDetailState createState() => _RegisterDetailState();
}

class _RegisterDetailState extends State<RegisterDetail> {
  ScrollController scrollController = ScrollController();

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController houseTypeController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController haveChildrenController = TextEditingController();
  TextEditingController childAgeController = TextEditingController();
  TextEditingController violentTendenciesController = TextEditingController();
  TextEditingController haveAgreementController = TextEditingController();
  TextEditingController havePetController = TextEditingController();

  TextEditingController reasonController = TextEditingController();

  final _repo = Repository();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      userNameController.text = widget.form.userName;
      emailController.text = widget.form.email;
      phoneController.text = widget.form.phone;
      jobController.text = widget.form.job;
      addressController.text = widget.form.address;
      houseTypeController.text = widget.form.houseType;
      frequencyController.text = widget.form.frequencyAtHome;
      haveChildrenController.text = widget.form.haveChildren;
      childAgeController.text = widget.form.childAge.toString();
      violentTendenciesController.text = widget.form.beViolentTendencies;
      haveAgreementController.text = widget.form.haveAgreement;
      havePetController.text = widget.form.havePet;
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi_VN');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(adoptregis),
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
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: registerInfo(context),
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
    );
  }

  _btnSubmitInformation(context) {
    if (widget.form.adoptionRegistrationStatus == 1) {
      return CustomCancelButton(
        label: 'HỦY ĐĂNG KÝ',
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 6,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "LÍ DO HỦY ĐƠN ĐĂNG KÝ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: CustomDivider(),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: TextFormField(
                              controller: reasonController,
                              maxLines: 5,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  counterText: '',
                                  hintText:
                                      'Hãy nhập lí do bạn hủy đơn đăng ký nhận nuôi...'),
                              maxLength: 1000,
                            )),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.white,
                              child: Text(
                                "HỦY ĐƠN",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (reasonController.text == null ||
                                    reasonController.text == '') {
                                  warningDialog(
                                    context,
                                    'Xin hãy nhập lí do bạn hủy đơn đăng ký này.',
                                    title: '',
                                    neutralText: 'Đóng',
                                    neutralAction: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                } else {
                                  confirmationDialog(context,
                                      'Bạn chắc chắn muốn hủy đơn đăng ký?',
                                      title: '',
                                      confirm: false,
                                      neutralText: 'Không',
                                      positiveText: 'Có', positiveAction: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => ProgressDialog(
                                              message: 'Đang hủy đơn đăng ký...',
                                            ));
                                    _repo
                                        .cancelAdoptionRegistrationForm(
                                            widget.form.adoptionRegistrationId,
                                            reasonController.text)
                                        .then((value) {
                                      if (value != null) {
                                        successDialog(
                                          context,
                                          'Đơn đăng ký nhận nuôi ${widget.form.pet.petName} đã hủy.',
                                          title: 'Đã hủy',
                                          neutralText: 'Đóng',
                                          neutralAction: () {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MyApp(),
                                              ),
                                            );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgressReportPage()));
                                          },
                                        );
                                      } else {
                                        warningDialog(
                                          context,
                                          'Không thể hủy đơn đăng ký này.',
                                          title: '',
                                          neutralText: 'Đóng',
                                          neutralAction: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      }
                                    });
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 8),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Đóng",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      );
    } else if (widget.form.adoptionRegistrationStatus == 2) {
      return CustomDisableButton(
        label: 'HỦY ĐĂNG KÝ',
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  convertStringtoDateTime(String date) {
    DateTime tmp = DateFormat('yyyy-MM-dd').parse(date);
    var result = DateFormat.yMMMMd('vi_VN').format(tmp);
    return result;
  }

  Widget registerInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
                  Icons.work,
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
                  Icons.location_city,
                  color: mainColor,
                ),
              ),
              enabled: false,
              maxLines: 2,
            ),
            SizedBox(
              height: 20,
            ),
            //* HOUSE TYPE
            TextFormField(
              controller: houseTypeController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Địa chỉ trên là',
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
                  Icons.location_city,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* FREQUENCY
            TextFormField(
              controller: frequencyController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Có thường ở nhà?',
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
            //* HAVE CHILDREN
            TextFormField(
              controller: haveChildrenController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Có trẻ em hay không?',
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
                  Icons.question_answer,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* CHILD AGE
            TextFormField(
              controller: childAgeController == null ? '' : childAgeController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Độ tuổi của trẻ (nếu có)',
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
                  Icons.question_answer,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* VIOLENT TENDENCIES
            TextFormField(
              controller: violentTendenciesController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText:
                    'Có bất kỳ thành viên nào trong gia đình bạn thể hiện\nhoặc có xu hướng bạo lực không?',
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
                  Icons.question_answer,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* HAVE AGREEMENT
            TextFormField(
              controller: haveAgreementController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText:
                    'Các thành viên trong gia đình có biết về quyết định\n nhận nuôi chó/mèo của bạn không?',
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
                  Icons.question_answer,
                  color: mainColor,
                ),
              ),
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            //* HAVE PET
            TextFormField(
              controller: havePetController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Có từng hoặc đang nuôi chó/mèo không?',
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
                  Icons.question_answer,
                  color: mainColor,
                ),
              ),
              enabled: false,
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
