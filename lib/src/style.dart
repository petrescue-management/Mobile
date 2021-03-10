import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

const Color common = Color.fromARGB(255, 235, 212, 206);

const Color color1 = Color(0xffFA696C);
const Color color2 = Color(0xffFA8165);
const Color color3 = Color(0xffFB8964);

const Color primaryGreen = Color(0xff416d6d);
const Color secondaryGreen = Color(0xff16a085);
Color fadedBlack = Colors.black.withAlpha(150);

List<BoxShadow> customShadow = [
  BoxShadow(
    color: Colors.grey[300],
    blurRadius: 30,
    offset: Offset(0, 10),
  ),
];

customTextField(String label, String error) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          validator: FormBuilderValidators.required(
            errorText: error,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );

customMultiLineTextField(String label, String error) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ],
    );

customRadioGroup(String label, String attribute, String error,
        List<FormBuilderFieldOption> options) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        FormBuilderRadioGroup(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          attribute: attribute,
          validators: [
            FormBuilderValidators.required(errorText: error),
          ],
          options: options,
          wrapSpacing: 60,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
