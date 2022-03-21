// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/constants/regular_color.dart';

class RegularButton extends StatelessWidget {
  RegularButton({
    Key? key,
    this.label,
    this.height = double.infinity,
    this.width = double.infinity,
    this.onPressed,
    this.primary = RegularColor.primary,
  }) : super(key: key);
  String? label;
  double height;
  double width;
  void Function()? onPressed;
  Color primary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label ?? "",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: primary,
        minimumSize: Size(
          width,
          height,
        ),
      ),
    );
  }
}
