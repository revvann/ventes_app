// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:ventes/constants/regular_color.dart';

class RegularButton extends StatelessWidget {
  RegularButton({
    Key? key,
    this.label,
    this.height = double.infinity,
    this.width = double.infinity,
    this.onPressed,
    this.primary = RegularColor.yellow,
    this.isLoading,
  }) : super(key: key);
  String? label;
  double height;
  double width;
  void Function()? onPressed;
  Color primary;
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: isLoading ?? false
          ? CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              label ?? "",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: primary,
        minimumSize: Size(
          width,
          height,
        ),
      ),
    );
  }
}
