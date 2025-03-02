import 'package:commons/commons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
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
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  ScrollController scrollController = ScrollController();

  final _repo = Repository();

  DatabaseReference _dbReference;

  @override
  void initState() {
    super.initState();

    _dbReference = FirebaseDatabase.instance
        .reference()
        .child('manager')
        .child('${widget.pet.centerId}')
        .child('Notification');

    _repo.getUserDetails().then((value) {
      setState(() {
        lastNameController.text = value.lastName;
        firstNameController.text = value.firstName;
        emailController.text = value.email;
        phoneNumberController.text = value.phone;
      });
    });
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
                                fontFamily: 'SamsungSans',
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
                                      final formInputs =
                                          _fbKey.currentState.value;
                                      print(formInputs);

                                      int ageVal = DateTime.now().year -
                                          DateTime.parse(
                                                  formInputs['dob'].toString())
                                              .year;
                                      if (ageVal < 20) {
                                        warningDialog(
                                          context,
                                          'Bạn chưa đạt độ tuổi yêu cầu (từ 20 tuổi trở lên).',
                                          title: '',
                                          neutralText: 'Đóng',
                                        );
                                      } else {
                                        if (this._currentStep <
                                            this._stepper().length - 1) {
                                          this._currentStep =
                                              this._currentStep + 1;
                                        } else {
                                          return;
                                        }
                                      }
                                    }
                                  });
                                },
                                onStepCancel: () {
                                  return;
                                },
                                controlsBuilder: (context,
                                    {onStepCancel, onStepContinue}) {
                                  if (_currentStep == 0) {
                                    return InkWell(
                                      onTap: onStepContinue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: primaryGreen,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
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
    if (_currentStep == 0) {
      return Container();
    } else {
      return CustomButton(
        label: 'Gửi yêu cầu',
        onTap: () {
          if (_fbKey.currentState.saveAndValidate()) {
            final formInputs = _fbKey.currentState.value;
            print(formInputs);

            if (formInputs['haveChildren'] == 'Không có' &&
                formInputs['childAge'] != 'Không có') {
              warningDialog(
                context,
                "Hãy chọn 'Độ tuổi' là 'Không có' nếu nhà bạn không có trẻ em.",
                title: '',
                neutralText: 'Đã hiểu',
              );
            } else {
              confirmationDialog(
                  context, 'Bạn chắc chắn muốn gửi đơn đăng ký nhận nuôi?',
                  title: '',
                  confirm: false,
                  neutralText: 'Không',
                  positiveText: 'Có', positiveAction: () async {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ProgressDialog(message: 'Đang gửi...'));

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

                if (formInputs['childAge'] == 'Dưới 5 tuổi') {
                  adopt.childAge = 1;
                } else if (formInputs['childAge'] == 'Dưới 10 tuổi') {
                  adopt.childAge = 2;
                } else if (formInputs['childAge'] == 'Dưới 15 tuổi') {
                  adopt.childAge = 3;
                } else {
                  adopt.childAge = 4;
                }

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

                _repo.createAdoptionRegistrationForm(adopt).then((value) {
                  if (value != null) {
                    successDialog(
                      context,
                      'Đơn đăng ký nhận nuôi của bạn đã được gửi đến trung tâm cứu hộ!',
                      neutralAction: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      },
                      title: "Thành công",
                      neutralText: 'Quay về trang chủ',
                    );

                    var currentDate = DateTime.now();
                    String currentDay = (currentDate.day < 10
                        ? '0${currentDate.day}'
                        : '${currentDate.day}');
                    String currentMonth = (currentDate.month < 10
                        ? '0${currentDate.month}'
                        : '${currentDate.month}');
                    String currentHour = (currentDate.hour < 10
                        ? '0${currentDate.hour}'
                        : '${currentDate.hour}');
                    String currentMinute = (currentDate.minute < 10
                        ? '0${currentDate.minute}'
                        : '${currentDate.minute}');
                    String currentSecond = (currentDate.second < 10
                        ? '0${currentDate.second}'
                        : '${currentDate.second}');
                    var notiDate =
                        '${currentDate.year}-$currentMonth-$currentDay $currentHour:$currentMinute:$currentSecond';

                    Map<String, dynamic> notification = {
                      'date': notiDate,
                      'isCheck': false,
                      'type': 1,
                    };

                    _dbReference.child(value).set(notification);
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
            }
          } else {
            warningDialog(
              context,
              'Bạn chưa điền đầy đủ thông tin.\nXin hãy kiểm tra lại.',
              title: '',
              neutralText: 'Đóng',
            );
          }
        },
      );
    }
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
                    controller: lastNameController,
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
                        errorText: 'Hãy nhập họ của bạn',
                      ),
                    ],
                    maxLength: 20,
                  ),
                ),
                //* FIRSTNAME
                Container(
                  width: 160,
                  child: FormBuilderTextField(
                    attribute: 'firstName',
                    controller: firstNameController,
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
                        errorText: 'Hãy nhập tên của bạn.',
                      ),
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
                format: DateFormat('dd/MM/yyyy'),
                attribute: 'dob',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh*',
                  labelStyle: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: 'Bạn phải từ 20 tuổi trở lên',
                  helperStyle: TextStyle(
                    color: primaryGreen,
                    fontStyle: FontStyle.italic,
                  ),
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
                    errorText: 'Hãy chọn ngày sinh của bạn.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            //* PHONE NUMBER
            Container(
              child: FormBuilderTextField(
                attribute: 'phone',
                controller: phoneNumberController,
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
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Hãy nhập số điện thoại của bạn',
                  ),
                  FormBuilderValidators.min(
                    10,
                    errorText: 'Số điện thoại không hợp lệ',
                  ),
                ],
                maxLengthEnforced: true,
                maxLength: 10,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            //* EMAIL
            Container(
              child: FormBuilderTextField(
                attribute: 'email',
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email*',
                  labelStyle: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: 'Ví dụ: rescueme@gmail.com',
                  helperStyle: TextStyle(
                    color: primaryGreen,
                    fontStyle: FontStyle.italic,
                  ),
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
                    errorText: 'Hãy nhập email của bạn.',
                  ),
                  FormBuilderValidators.email(
                    errorText: 'Email không hợp lệ.',
                  ),
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
            //* house type
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
            //* frequencyAtHome
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
            //* haveChildren
            customRadioGroup(
              'Có trẻ em hay không?*',
              'haveChildren',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Có'),
                FormBuilderFieldOption(value: 'Không có'),
              ],
            ),
            //* childAge
            customRadioGroup(
              'Độ tuổi của trẻ (Nếu nhà bạn không có trẻ em, hãy chọn "Không có")*',
              'childAge',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Dưới 5 tuổi'),
                FormBuilderFieldOption(value: 'Dưới 10 tuổi'),
                FormBuilderFieldOption(value: 'Dưới 15 tuổi'),
                FormBuilderFieldOption(value: 'Không có'),
              ],
            ),
            //* beViolentTendencies
            customRadioGroup(
              'Có bất kỳ thành viên nào trong gia đình bạn thể hiện\nhoặc có xu hướng bạo lực không?*',
              'beViolentTendencies',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Có'),
                FormBuilderFieldOption(value: 'Không có'),
              ],
            ),
            //* haveAgreement
            customRadioGroup(
              'Các thành viên trong gia đình có biết về quyết định\n nhận nuôi chó/mèo của bạn không?*',
              'haveAgreement',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Có'),
                FormBuilderFieldOption(value: 'Không'),
              ],
            ),
            //* havePet
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
