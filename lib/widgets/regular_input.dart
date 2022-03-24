// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/constants/regular_color.dart';

class RegularInput extends StatelessWidget {
  RegularInput({Key? key, this.label, this.isPassword = false, this.inputType, this.validator, this.controller}) : super(key: key);
  String? label;
  bool isPassword;
  TextInputType? inputType;
  String? Function(String?)? validator;
  TextEditingController? controller;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: RegularColor.dark,
          ),
        ),
        TextFormField(
          key: _key,
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          autocorrect: !isPassword,
          validator: validator,
          style: TextStyle(
            fontSize: 14,
            color: RegularColor.dark,
          ),
          onChanged: (value) {
            _key.currentState?.validate();
          },
          onFieldSubmitted: (value) {
            _key.currentState?.validate();
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.gray,
                width: 2,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.gray,
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
          ),
        ),
      ],
    );
  }
}
