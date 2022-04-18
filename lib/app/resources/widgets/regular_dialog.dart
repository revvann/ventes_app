// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularDialog {
  RegularDialog({
    required this.width,
    this.height,
    required this.child,
    this.dismissable = true,
  });
  double width;
  double? height;
  Widget child;
  bool dismissable;

  Future show() {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RegularSize.m)),
        insetPadding: EdgeInsets.symmetric(
          horizontal: (Get.width - width) / 2,
          vertical: (Get.height - (height ?? Get.height)) / 2,
        ),
        child: Column(
          mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(RegularSize.m),
              child: child,
            ),
          ],
        ),
      ),
      barrierDismissible: dismissable,
    );
  }
}
