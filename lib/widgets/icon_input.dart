// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class IconInput extends StatelessWidget {
  IconInput({
    Key? key,
    this.label,
    this.isPassword = false,
    this.inputType,
    this.validator,
    this.controller,
    required this.icon,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);
  String? label;
  bool isPassword;
  bool enabled;
  TextInputType? inputType;
  String? Function(String?)? validator;
  TextEditingController? controller;
  String icon;
  String? hintText;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  Color _activeColor = RegularColor.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? "",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: RegularColor.dark,
            ),
          ),
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              if (focus) {
                _activeColor = RegularColor.primary;
              } else {
                _activeColor = RegularColor.disable;
              }
            },
            child: TextFormField(
              enabled: enabled,
              key: _key,
              controller: controller,
              keyboardType: inputType,
              obscureText: isPassword,
              enableSuggestions: !isPassword,
              autocorrect: !isPassword,
              validator: validator,
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
                prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: RegularSize.s,
                  ),
                  child: SvgPicture.asset(
                    icon,
                    color: _activeColor,
                    width: RegularSize.m,
                  ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
