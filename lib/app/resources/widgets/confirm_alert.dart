// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class ConfirmAlert {
  ConfirmAlert(this.message);
  String message;

  Future<bool> show() async {
    bool result = false;
    await RegularDialog(
      width: Get.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/question.png',
            width: 75,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          Text(
            "Confirmation",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Get.close(1);
                },
                style: TextButton.styleFrom(
                  primary: RegularColor.red,
                ),
                child: Text(
                  "Don't",
                  style: TextStyle(
                    color: RegularColor.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  result = true;
                  Get.close(1);
                },
                style: TextButton.styleFrom(
                  primary: RegularColor.green,
                ),
                child: Text(
                  "Okay",
                  style: TextStyle(
                    color: RegularColor.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).show();
    return result;
  }
}
