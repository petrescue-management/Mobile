import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:commons/commons.dart';
import 'package:pet_rescue_mobile/src/custom_button.dart';
import 'package:pet_rescue_mobile/views/progress/progress_report.dart';
// import 'package:intl/intl.dart';
// import 'package:pet_rescue_mobile/models/example/temp.dart';
// import 'package:pet_rescue_mobile/models/example/temp_data.dart';
// import 'package:pet_rescue_mobile/src/style.dart';

class RescueForm extends StatefulWidget {
  const RescueForm({Key key}) : super(key: key);

  @override
  _RescueFormState createState() => _RescueFormState();
}

class _RescueFormState extends State<RescueForm> {
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rescue', style: TextStyle(
            color: Colors.black
          ),),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            FormBuilder(
                key: _fbKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        _rescueForm(),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomButton(
                                    label: 'Submit',
                                    onTap: () {
                                      if (_fbKey.currentState
                                          .saveAndValidate()) {
                                        final formInputs =
                                            _fbKey.currentState.value;
                                        print(formInputs);
                                        successDialog(
                                          context, 
                                          "Your rescue request has been sent!!",
                                          neutralAction: () {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProgressReportPage()));
                                          }
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
                                    }),
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ));
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
                        errorText: "Please upload an image")
                  ],
                  maxImages: 1,
                  imageHeight: MediaQuery.of(context).size.height * 0.3,
                  imageWidth: MediaQuery.of(context).size.width * 0.85,
                ),
              ),
              //* RADIO
              Container(
                  child: Column(
                children: [
                  FormBuilderRadioGroup(
                    wrapAlignment: WrapAlignment.center,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: ("How's the pet?"),
                        labelStyle: TextStyle(
                          fontSize: 24,
                        )),
                    attribute: 'radio',
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please select the pet's situation")
                    ],
                    options: [
                      FormBuilderFieldOption(value: 'Abandoned'),
                      FormBuilderFieldOption(value: 'Injured'),
                    ],
                    wrapSpacing: 20,
                  ),
                ],
              )),
              //* DESCRIPTION
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ("Please describe more..."),
                            labelStyle: TextStyle(
                              fontSize: 24,
                            )),
                        attribute: 'description',
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildRadioDropdownAndSwitchWidgets() {
  //   var options = ["Option 1", "Option 2", "Option 3"];

  //   return Container(
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: <Widget>[
  //             //* ----------------------------------------------------
  //             //* RADIO
  //             //* ----------------------------------------------------
  //             Text('Radio',
  //                 style: TextStyle(fontSize: 20, color: Colors.black)),
  //             FormBuilderRadio(
  //               decoration: InputDecoration(labelText: 'Your feedback:'),
  //               validators: [FormBuilderValidators.required()],
  //               attribute: 'radio',
  //               options: [
  //                 FormBuilderFieldOption(value: 'Awesome'),
  //                 FormBuilderFieldOption(value: 'Good'),
  //                 FormBuilderFieldOption(value: 'Bad'),
  //               ],
  //             ),
  //             SizedBox(height: 20),
  //             FormBuilderTextField(
  //               attribute: 'reason',
  //               decoration: InputDecoration(labelText: 'If bad, why?'),
  //               validators: [
  //                 (val) {
  //                   if (_fbKey.currentState.fields['radio'].currentState
  //                               .value ==
  //                           'Bad' &&
  //                       (val == null || val.toString().isEmpty)) {
  //                     return 'Please tell us why it\'s bad';
  //                   }
  //                 }
  //               ],
  //             ),
  //             FormBuilderCustomField(
  //               attribute: 'mycustomfield',
  //               formField: FormField(builder: (FormFieldState<dynamic> field) {
  //                 return InputDecorator(
  //                   decoration: InputDecoration(
  //                     labelText: "Select option",
  //                     contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
  //                     border: InputBorder.none,
  //                     errorText: field.errorText,
  //                   ),
  //                   child: Container(
  //                     height: 200,
  //                     child: CupertinoPicker(
  //                       itemExtent: 30,
  //                       children: options.map((c) => Text(c)).toList(),
  //                       onSelectedItemChanged: (index) {
  //                         field.didChange(options[index]);
  //                       },
  //                     ),
  //                   ),
  //                 );
  //               }),
  //             ),

  //             //* ----------------------------------------------------
  //             //* RADIO GROUP
  //             //* ----------------------------------------------------
  //             // Text('Radio Group',
  //             //     style: TextStyle(fontSize: 20, color: Colors.black)),
  //             // FormBuilderRadioGroup(
  //             //   attribute: 'radio_group',
  //             //   options: [
  //             //     FormBuilderFieldOption(value: 'Option A'),
  //             //     FormBuilderFieldOption(value: 'Option B'),
  //             //     FormBuilderFieldOption(value: 'Option C'),
  //             //   ],
  //             // ),
  //             // SizedBox(height: 20),
  //             //* ----------------------------------------------------
  //             //* DROPDOWN
  //             //* ----------------------------------------------------
  //             // Text('Dropdown',
  //             //     style: TextStyle(fontSize: 20, color: Colors.black)),
  //             // FormBuilderDropdown(
  //             //   hint: Text('Select Gender'),
  //             //   attribute: 'dropdown',
  //             //   items: ['Male', 'Female', 'Other']
  //             //       .map((gender) =>
  //             //           DropdownMenuItem(value: gender, child: Text("$gender")))
  //             //       .toList(),
  //             // ),
  //             // SizedBox(height: 20),
  //             //* ----------------------------------------------------
  //             //* SWITCH
  //             //* ----------------------------------------------------
  //             // Text('Switch',
  //             //     style: TextStyle(fontSize: 20, color: Colors.black)),
  //             // FormBuilderSwitch(attribute: 'switch', label: Text('On or off')),
  //             // SizedBox(height: 20),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTextInputWidgets(context) {
  //   final TextEditingController _typeAheadController = TextEditingController();
  //   String _selectedCity;
  //   String _emailPattern =
  //       r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  //   return Container(
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: <Widget>[
  //           Text('Text Input',
  //               style: TextStyle(fontSize: 20, color: Colors.black)),
  //           //* ----------------------------------------------------
  //           //* TEXT INPUT
  //           //* ----------------------------------------------------
  //           FormBuilderTextField(
  //             maxLines: 1,
  //             obscureText: false,
  //             attribute: 'textfield',
  //             readOnly: false,
  //             validators: [
  //               //* General
  //               // FormBuilderValidators.required(),
  //               //* Numeric
  //               // FormBuilderValidators.numeric(),
  //               // FormBuilderValidators.min(0),
  //               // FormBuilderValidators.max(100),
  //               //* Strings
  //               // FormBuilderValidators.minLength(10),
  //               // FormBuilderValidators.maxLength(15),
  //               // FormBuilderValidators.pattern(_emailPattern),
  //               // FormBuilderValidators.email(),
  //               // FormBuilderValidators.url(),
  //               //FormBuilderValidators.IP(),
  //               // FormBuilderValidators.creditCard(),
  //               // 4137868152556047 16-digits
  //               //* Date
  //               // FormBuilderValidators.date(),
  //               //* Boolean
  //               //FormBuilderValidators.requiredTrue(),
  //               //* Custom validator
  //               // (val) {
  //               //   if (val.toLowerCase() != "yes")
  //               //     return "The answer must be Yes";
  //               // }
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           Text('Phone Field',
  //               style: TextStyle(fontSize: 20, color: Colors.black)),
  //           //* ----------------------------------------------------
  //           //* PHONE FIELD
  //           //* ----------------------------------------------------
  //           FormBuilderPhoneField(attribute: 'phone'),
  //           SizedBox(height: 20),
  //           Text('Type Ahead',
  //               style: TextStyle(fontSize: 20, color: Colors.black)),
  //           //* ----------------------------------------------------
  //           //* TYPE AHEAD
  //           //* ----------------------------------------------------
  //           FormBuilderTypeAhead(
  //             attribute: 'type_ahead',
  //             textFieldConfiguration: TextFieldConfiguration(
  //                 controller: _typeAheadController,
  //                 decoration: InputDecoration(labelText: 'City')),
  //             suggestionsCallback: (pattern) {
  //               return CitiesService.getSuggestions(pattern);
  //             },
  //             itemBuilder: (context, suggestion) {
  //               return ListTile(
  //                 title: Text(suggestion),
  //               );
  //             },
  //             transitionBuilder: (context, suggestionsBox, controller) {
  //               return suggestionsBox;
  //             },
  //             onSuggestionSelected: (suggestion) {
  //               _typeAheadController.text = suggestion;
  //             },
  //             onSaved: (value) => _selectedCity = value,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  //   Widget _nextBuildMethod() {
  //   return Container(
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: <Widget>[
  //           Text('Name', style: TextStyle(fontSize: 20, color: Colors.black)),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
