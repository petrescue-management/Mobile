import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pet_rescue_mobile/src/style.dart';

customText(String label, String hintText) => Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextField(
        decoration: InputDecoration(
          focusColor: color2,
          hintMaxLines: 2,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: TextStyle(
            height: 0.5,
            color: color2,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color2),
          ),
        ),
      ),
    );

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
        FormBuilderRadioGroup(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: color2,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: color2,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          attribute: attribute,
          validators: [
            FormBuilderValidators.required(errorText: error),
          ],
          options: options,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
