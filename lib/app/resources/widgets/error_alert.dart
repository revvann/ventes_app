// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class ErrorAlert {
  ErrorAlert(this.message);
  String message;

  Future show() {
    return RegularDialog(
      width: Get.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            width: 75,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          Text(
            "Error",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: RegularColor.gray,
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
          TextButton(
            onPressed: () {
              Get.close(1);
            },
            style: TextButton.styleFrom(
              primary: RegularColor.red,
            ),
            child: Text(
              "Okay",
              style: TextStyle(
                color: RegularColor.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ).show();
  }
}
