import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:commons/commons.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue_detail.dart';
// import 'package:intl/intl.dart';
// import 'package:pet_rescue_mobile/models/example/temp.dart';
// import 'package:pet_rescue_mobile/models/example/temp_data.dart';

// ignore: must_be_immutable
class Rescue extends StatefulWidget {
  String location;

  Rescue({
    this.location,
  });

  @override
  _RescueState createState() => _RescueState();
}

class _RescueState extends State<Rescue> {
  ScrollController scrollController = ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Cứu hộ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
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
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                FormBuilder(
                  key: _fbKey,
                  child: Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _rescueForm(),
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
                                      "Yêu cầu của bạn đã được gửi đến các trạm cứu hộ!",
                                      neutralAction: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RescueDetail(),
                                          ),
                                        );
                                      },
                                      title: "Thành công",
                                    );
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (_) => AlertDialog(
                                    //           title: Text('Form inputs'),
                                    //           content: Text('$formInputs'),
                                    //           actions: [
                                    //             FlatButton(
                                    //                 child: Text('Close'),
                                    //                 onPressed: () {
                                    //                   Navigator.of(context)
                                    //                       .pop();
                                    //                 })
                                    //           ],
                                    //         )
                                    //         );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _rescueForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //* IMAGE PICKER
              Container(
                alignment: Alignment.center,
                child: FormBuilderImagePicker(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  attribute: 'image_picker',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Bạn chưa upload ảnh !"),
                  ],
                  maxImages: 1,
                  imageHeight: MediaQuery.of(context).size.height * 0.3,
                  imageWidth: MediaQuery.of(context).size.width * 0.85,
                ),
              ),
              SizedBox(height: 20),
              //* RADIO
              Container(
                child: customRadioGroup(
                  'Tình trạng của vật nuôi',
                  'radioPetStatus',
                  'Bạn chưa chọn tình trạng của vật nuôi',
                  [
                    FormBuilderFieldOption(value: 'Đi lạc'),
                    FormBuilderFieldOption(value: 'Bị bỏ rơi'),
                    FormBuilderFieldOption(value: 'Bị thương'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //* DESCRIPTION
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: customMultiLineTextField('Hãy mô tả thêm', ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
