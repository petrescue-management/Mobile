import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/models/pet/pet_model.dart';
import 'package:pet_rescue_mobile/src/style.dart';

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
                });
              },
            ),
          ),
          body: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                  child: Container(
                    height: height * 0.16,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: color2, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(widget.pet.petImgUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.pet.petName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Tuổi: ' + widget.pet.petAge,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Giống: ' + widget.pet.petBreedName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomDivider(),
                FormBuilder(
                  key: _fbKey,
                  child: Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Stepper(
                            steps: _stepper(),
                            type: StepperType.horizontal,
                            physics: ClampingScrollPhysics(),
                            currentStep: this._currentStep,
                            onStepTapped: (step) {
                              setState(() {
                                this._currentStep = step;
                              });
                            },
                            onStepContinue: () {
                              setState(() {
                                if (this._currentStep <
                                    this._stepper().length - 1) {
                                  this._currentStep = this._currentStep + 1;
                                } else {
                                  _currentStep = 0;
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                label: 'Gửi yêu cầu',
                                onTap: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    final formInputs =
                                        _fbKey.currentState.value;
                                    print(formInputs);
                                    successDialog(
                                      context,
                                      'Đơn đăng ký nhận nuôi của bạn đã được gửi đến trạm cứu hộ!',
                                      // neutralAction: () {
                                      //   Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => RescueDetail(),
                                      //     ),
                                      //   );
                                      // },
                                      title: "Thành công",
                                    );
                                  } else {
                                    warningDialog(context,
                                        'Bạn chưa điền đầy đủ thông tin.\nXin hãy kiểm tra lại.',
                                        title: '');
                                  }
                                },
                              ),
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
        ),
      ),
    );
  }

  List<Step> _stepper() {
    List<Step> _steps = [
      //personal information
      Step(
        title: Text('Thông tin cá nhân'),
        content: Column(
          children: [
            customTextField('Họ tên', 'Bạn chưa điền họ tên.'),
            customTextField('Năm sinh', 'Bạn chưa điền năm sinh.'),
            Container(
              child: FormBuilderPhoneField(
                attribute: 'phone_number',
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                priorityListByIsoCode: ['KE'],
                validators: [
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.required(
                      errorText: 'Hãy nhập số điện thoại của bạn'),
                ],
              ),
            ),
            customTextField('Email', 'Bạn chưa điền email.'),
            customTextField('Nghề nghiệp', 'Bạn chưa điền nghề nghiệp.'),
            customTextField('Địa chỉ', 'Bạn chưa điền địa chỉ.'),
            customRadioGroup(
              'Địa chỉ trên là:',
              'radioAddressType',
              'Chưa trả lời',
              [
                FormBuilderFieldOption(value: 'Nhà riêng'),
                FormBuilderFieldOption(value: 'Nhà trọ'),
                FormBuilderFieldOption(value: 'Nhà người quen'),
                FormBuilderFieldOption(value: 'Khác')
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
                'Bạn có thường ở nhà không?',
                'radioStayHomeFrequency',
                'Chưa trả lời',
                [
                  FormBuilderFieldOption(value: 'Chỉ về ngủ'),
                  FormBuilderFieldOption(value: 'Đi làm - Về nhà'),
                  FormBuilderFieldOption(value: 'Thường đi vắng'),
                  FormBuilderFieldOption(value: 'Thường xuyên ở nhà')
                ],
              ),
              customRadioGroup(
                'Có trẻ em hay không?',
                'radioChildrenAvailable',
                'Chưa trả lời',
                [
                  FormBuilderFieldOption(value: 'Có'),
                  FormBuilderFieldOption(value: 'Không'),
                ],
              ),
              customTextField('Độ tuổi của trẻ (Nếu có):', null),
              SizedBox(height: 10),
              customRadioGroup(
                'Có bất kỳ thành viên nào trong gia đình bạn thể hiện hoặc có xu hướng bạo lực không?',
                'radioViolatedAvailable',
                'Chưa trả lời',
                [
                  FormBuilderFieldOption(value: 'Có'),
                  FormBuilderFieldOption(value: 'Không'),
                  FormBuilderFieldOption(value: 'Khác'),
                ],
              ),
              customRadioGroup(
                'Các thành viên trong gia đình có biết về quyết định nhận nuôi chó/mèo của bạn không?',
                'radioDecision',
                'Chưa trả lời',
                [
                  FormBuilderFieldOption(value: 'Có'),
                  FormBuilderFieldOption(value: 'Không'),
                  FormBuilderFieldOption(value: 'Khác'),
                ],
              ),
              customRadioGroup(
                'Bạn có từng hoặc đang nuôi chó/mèo không?',
                'radioAdopted',
                'Chưa trả lời',
                [
                  FormBuilderFieldOption(value: 'Đã từng nuôi'),
                  FormBuilderFieldOption(value: 'Đang nuôi'),
                  FormBuilderFieldOption(value: 'Chưa từng nuôi'),
                ],
              ),
            ],
          ),
          isActive: _currentStep >= 1,
          state: StepState.indexed),
    ];
    return _steps;
  }
}
