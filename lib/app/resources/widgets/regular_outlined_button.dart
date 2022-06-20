// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ventes/constants/regular_color.dart';

class RegularOutlinedButton extends StatelessWidget {
  RegularOutlinedButton({
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
                color: primary,
              ),
            ),
      style: TextButton.styleFrom(
        splashFactory: InkSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(
          color: primary,
        ),
        backgroundColor: Colors.white,
        minimumSize: Size(
          width,
          height,
        ),
      ),
    );
  }
}
