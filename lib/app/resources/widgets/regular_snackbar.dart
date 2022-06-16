// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularSnackbar {
  RegularSnackbar({
    required this.message,
    required this.icon,
    required this.color,
  });
  String message;
  String icon;
  Color color;

  Future show() {
    return Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        icon: SvgPicture.asset(
          icon,
          color: Colors.white,
          width: RegularSize.m,
        ),
        backgroundColor: color,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(RegularSize.l),
        borderRadius: RegularSize.s,
        snackPosition: SnackPosition.TOP,
      ),
    ).future;
  }
}
