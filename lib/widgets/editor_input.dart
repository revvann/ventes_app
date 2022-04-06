import 'package:flutter/material.dart';
import 'package:ventes/widgets/regular_input.dart';

class EditorInput extends StatelessWidget {
  EditorInput({
    Key? key,
    this.label,
    this.isPassword = false,
    this.validator,
    this.controller,
    this.hintText,
    this.value,
    this.enabled,
  }) : super(key: key);
  String? label;
  String? hintText;
  String? value;
  bool? enabled;
  bool isPassword;
  String? Function(String?)? validator;
  TextEditingController? controller;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RegularInput(
        key: _key,
        maxLines: null,
        label: label,
        isPassword: isPassword,
        inputType: TextInputType.multiline,
        validator: validator,
        controller: controller,
        hintText: hintText,
        value: value,
        enabled: enabled,
      ),
    );
  }
}
