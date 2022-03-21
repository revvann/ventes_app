// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/constants/regular_color.dart';

class RegularInput extends StatelessWidget {
  RegularInput({Key? key, this.label, this.isPassword = false, this.inputType}) : super(key: key);
  String? label;
  bool isPassword;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: RegularColor.gray_3,
          ),
        ),
        TextFormField(
          keyboardType: inputType,
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          autocorrect: !isPassword,
          style: TextStyle(
            fontSize: 14,
            color: RegularColor.dark_2,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.gray_4,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.gray_4,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.primary,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: RegularColor.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
