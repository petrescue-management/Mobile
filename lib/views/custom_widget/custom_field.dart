import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
