import 'package:commons/commons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';
import 'package:pet_rescue_mobile/main.dart';

// ignore: must_be_immutable
class AdoptFormRegistrationPage extends StatefulWidget {
  PetModel pet;

  AdoptFormRegistrationPage({this.pet});

  @override
  _AdoptFormRegistrationPageState createState() =>
      _AdoptFormRegistrationPageState();
}

class _AdoptFormRegistrationPageState extends State<AdoptFormRegistrationPage> {
  int _currentStep = 0;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  ScrollController scrollController = ScrollController();

  final _repo = Repository();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _confirmPop() {
    return confirmationDialog(context, "Bạn muốn hủy đăng ký nhận nuôi ?",
        positiveText: "Có",
        neutralText: "Không",
        confirm: false,
        title: "", positiveAction: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: _confirmPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Đăng ký nhận nuôi',
              style: TextStyle(
                color: Colors.black,
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
                confirmationDialog(context, "Bạn muốn hủy đăng ký nhận nuôi ?",
                    positiveText: "Có",
                    neutralText: "Không",
                    confirm: false,
                    title: "", positiveAction: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: Stack(children: [
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
              height: height,
              width: width,
              child: Column(
                children: [
                  FormBuilder(
                    key: _fbKey,
                    child: Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Theme(
                              data: ThemeData(
                                primaryColor: primaryGreen,
                                fontFamily: 'Philosopher',
                              ),
                              child: Stepper(
                                steps: _stepper(),
                                type: StepperType.horizontal,
                                physics: ClampingScrollPhysics(),
                                currentStep: this._currentStep,
                                onStepTapped: (step) {
                                  return;
                                },
                                onStepContinue: () {
                                  setState(() {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      if (this._currentStep <
                                          this._stepper().length - 1) {
                                        this._currentStep =
                                            this._currentStep + 1;
                                      } else {
                                        _currentStep = 0;
                                      }
                                    }
                                  });
                                },
                                onStepCancel: () {
                                  setState(() {
                                    if (this._currentStep > 0) {
                                      this._currentStep = this._currentStep - 1;
                                    } else {
                                      this._currentStep = 0;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _btnSubmitAdoptForm(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _btnSubmitAdoptForm(context) {
    return CustomButton(
      label: 'Gửi yêu cầu',
      onTap: () {
        if (_fbKey.currentState.saveAndValidate()) {
          final formInputs = _fbKey.currentState.value;
          print(formInputs);

          confirmationDialog(
              context, 'Bạn chắc chắn muốn gửi đơn đăng ký nhận nuôi?',
              title: '',
              confirm: false,
              negativeText: 'Không',
              positiveText: 'Có', positiveAction: () async {
            showDialog(
                context: context,
                builder: (context) => ProgressDialog(message: 'Đang gửi...'));

            AdoptForm adopt = new AdoptForm();
            adopt.petProfileId = widget.pet.petProfileId;
            adopt.userName =
                '${formInputs['lastName']} ${formInputs['firstName']}';
            adopt.phone = formInputs['phone'];
            adopt.email = formInputs['email'];
            adopt.job = formInputs['job'];
            adopt.dob = formInputs['dob'].toString();
            adopt.address = formInputs['address'];

            if (formInputs['houseType'] == 'Nhà riêng') {
              adopt.houseType = 1;
            } else if (formInputs['houseType'] == 'Chung cư') {
              adopt.houseType = 2;
            } else if (formInputs['houseType'] == 'Nhà trọ') {
              adopt.houseType = 3;
            } else if (formInputs['houseType'] ==
                'Nhà của bạn hoặc người thân') {
              adopt.houseType = 4;
            } else {
              adopt.houseType = 5;
            }

            if (formInputs['frequencyAtHome'] == 'Chỉ về ngủ') {
              adopt.frequencyAtHome = 1;
            } else if (formInputs['frequencyAtHome'] == 'Đi làm - Về nhà') {
              adopt.frequencyAtHome = 2;
            } else if (formInputs['frequencyAtHome'] == 'Thường đi vắng') {
              adopt.frequencyAtHome = 3;
            } else {
              adopt.frequencyAtHome = 4;
            }

            if (formInputs['haveChildren'] == 'Có') {
              adopt.haveChildren = true;
            } else {
              adopt.haveChildren = false;
            }

            adopt.childAge = formInputs['childAge'];

            if (formInputs['beViolentTendencies'] == 'Có') {
              adopt.beViolentTendencies = true;
            } else {
              adopt.beViolentTendencies = false;
            }

            if (formInputs['haveAgreement'] == 'Có') {
              adopt.haveAgreement = true;
            } else {
              adopt.haveAgreement = false;
            }

            if (formInputs['havePet'] == 'Đã từng nuôi') {
              adopt.havePet = 1;
            } else if (formInputs['havePet'] == 'Chưa từng nuôi') {
              adopt.havePet = 2;
            } else {
              adopt.havePet = 3;
            }

            _repo.createAdopttionRegistrationForm(adopt).then((value) {
              if (value != null) {
                print('alo: ' + value);

                successDialog(
                  context,
                  'Đơn đăng ký nhận nuôi của bạn đã được gửi đến trạm cứu hộ!',
                  neutralAction: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  title: "Thành công",
                );
              } else {
                warningDialog(
                  context,
                  'Lỗi hệ thống',
                  title: '',
                  neutralAction: () {
                    Navigator.pop(context);
                  },
                );
              }
            });
          });
        } else {
          warningDialog(
            context,
            'Bạn chưa điền đầy đủ thông tin.\nXin hãy kiểm tra lại.',
            title: '',
            neutralAction: () {
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }

  List<Step> _stepper() {
    List<Step> _steps = [
      //personal information
      Step(
        title: Text('Thông tin cá nhân'),
        content: Column(
          children: [
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
            SizedBox(height: 20),
            //* DATE OF BIRTH
            Container(
              child: FormBuilderDateTimePicker(
                attribute: 'dob',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh*',
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
            SizedBox(height: 20),
            //* PHONE NUMBER
            Container(
              child: FormBuilderPhoneField(
                attribute: 'phone',
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Số điện thoại*',
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
            //* EMAIL
            Container(
              child: FormBuilderTextField(
                attribute: 'email',
                decoration: InputDecoration(
                  labelText: 'Email*',
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
            SizedBox(height: 20),
            //* JOB
            Container(
              child: FormBuilderTextField(
                attribute: 'job',
                decoration: InputDecoration(
                  labelText: 'Nghề nghiệp*',
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
                  prefixIcon: Icon(
                    Icons.work,
                    color: primaryGreen,
                  ),
                ),
                validators: [
                  FormBuilderValidators.required(
                      errorText: 'Hãy nhập nghề nghiệp của bạn.'),
                ],
                maxLength: 50,
              ),
            ),
            SizedBox(height: 20),
            //* ADDRESS
            Container(
              child: FormBuilderTextField(
                attribute: 'address',
                decoration: InputDecoration(
                  labelText: 'Địa chỉ*',
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
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: primaryGreen,
                  ),
                ),
                validators: [
                  FormBuilderValidators.required(
                      errorText: 'Hãy nhập địa chỉ của bạn.'),
                ],
                maxLength: 250,
                maxLines: 3,
              ),
            ),
            SizedBox(height: 20),
            customRadioGroup(
              'Địa chỉ trên là:',
              'houseType',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Nhà riêng'),
                FormBuilderFieldOption(value: 'Chung cư'),
                FormBuilderFieldOption(value: 'Nhà trọ'),
                FormBuilderFieldOption(value: 'Khác'),
                FormBuilderFieldOption(value: 'Nhà của bạn hoặc người thân'),
              ],
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.indexed,
      ),
      //more information
      Step(
        title: Text('Câu hỏi thêm'),
        content: Column(
          children: [
            customRadioGroup(
              'Bạn có thường ở nhà không?*',
              'frequencyAtHome',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Chỉ về ngủ'),
                FormBuilderFieldOption(value: 'Đi làm - Về nhà'),
                FormBuilderFieldOption(value: 'Thường đi vắng'),
                FormBuilderFieldOption(value: 'Thường xuyên ở nhà')
              ],
            ),
            customRadioGroup(
              'Có trẻ em hay không?*',
              'haveChildren',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Có'),
                FormBuilderFieldOption(value: 'Không'),
              ],
            ),
            Container(
              child: FormBuilderTextField(
                attribute: 'childAge',
                decoration: InputDecoration(
                  labelText: 'Độ tuổi của trẻ (Nếu có)',
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
                  prefixIcon: Icon(
                    Icons.edit_outlined,
                    color: primaryGreen,
                  ),
                ),
                maxLength: 2,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            customRadioGroup(
              'Có bất kỳ thành viên nào trong gia đình bạn thể hiện\nhoặc có xu hướng bạo lực không?*',
              'beViolentTendencies',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Có'),
                FormBuilderFieldOption(value: 'Không'),
              ],
            ),
            customRadioGroup(
              'Các thành viên trong gia đình có biết về quyết định\n nhận nuôi chó/mèo của bạn không?*',
              'haveAgreement',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Có'),
                FormBuilderFieldOption(value: 'Không'),
              ],
            ),
            customRadioGroup(
              'Bạn có từng hoặc đang nuôi chó/mèo không?*',
              'havePet',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Đã từng nuôi'),
                FormBuilderFieldOption(value: 'Chưa từng nuôi'),
                FormBuilderFieldOption(value: 'Đang nuôi'),
              ],
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        state: StepState.indexed,
      ),
    ];
    return _steps;
  }
}
