// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class IconButton extends StatelessWidget {
  IconButton({
    Key? key,
    required this.icon,
    this.height = double.infinity,
    this.width = double.infinity,
    this.onPressed,
    this.primary = RegularColor.yellow,
    this.isLoading,
    this.iconSize = RegularSize.m,
    this.foregroundColor = Colors.white,
  }) : super(key: key);
  String icon;
  double height;
  double width;
  void Function()? onPressed;
  Color primary;
  Color foregroundColor;
  bool? isLoading;
  double? iconSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: isLoading ?? false
          ? CircularProgressIndicator(
              color: Colors.white,
            )
          : SvgPicture.asset(
              icon,
              color: foregroundColor,
              width: iconSize,
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
