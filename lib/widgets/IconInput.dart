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
  }) : super(key: key);
  String? label;
  bool isPassword;
  TextInputType? inputType;
  String? Function(String?)? validator;
  TextEditingController? controller;
  String icon;
  String? hintText;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final _activeColor = RegularColor.gray.obs;

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
            color: RegularColor.dark,
          ),
        ),
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              if (focus) {
                _activeColor.value = RegularColor.primary;
              } else {
                _activeColor.value = RegularColor.disable;
              }
            },
            child: Obx(
              () {
                return TextFormField(
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
                    prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: RegularSize.s,
                      ),
                      child: SvgPicture.asset(
                        icon,
                        color: _activeColor.value,
                        width: RegularSize.m,
                      ),
                    ),
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
