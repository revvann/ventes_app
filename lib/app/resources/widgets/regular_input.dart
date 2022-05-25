// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ventes/constants/regular_color.dart';

class RegularInput extends StatelessWidget {
  RegularInput({
    Key? key,
    this.label,
    this.isPassword = false,
    this.inputType,
    this.validator,
    this.controller,
    this.hintText,
    this.value,
    this.enabled,
    this.maxLines,
    this.inputFormatters,
  }) : super(key: key);
  String? label;
  String? hintText;
  String? value;
  bool? enabled;
  bool isPassword;
  int? maxLines;
  TextInputType? inputType;
  String? Function(String?)? validator;
  TextEditingController? controller;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: RegularColor.primary,
          ),
        ),
        TextFormField(
          key: _key,
          maxLines: maxLines,
          initialValue: value,
          enabled: enabled,
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          autocorrect: !isPassword,
          validator: validator,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 16,
            color: RegularColor.dark,
          ),
          onChanged: (value) {
            _key.currentState?.validate();
          },
          onFieldSubmitted: (value) {
            _key.currentState?.validate();
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: RegularColor.gray,
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.disable,
                width: 2,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.disable,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.primary,
                width: 2,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.red,
                width: 2,
              ),
            ),
            errorStyle: TextStyle(
              color: RegularColor.red,
            ),
          ),
        ),
      ],
    );
  }
}
