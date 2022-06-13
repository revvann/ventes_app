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
    this.backgroundColor = Colors.white,
    this.padding,
    this.alignment = Alignment.center,
    this.onWillPop,
  });
  double width;
  double? height;
  Widget child;
  bool dismissable;
  Color? backgroundColor;
  EdgeInsets? padding;
  Alignment alignment;
  Future<bool> Function()? onWillPop;

  Future show() {
    return Get.dialog(
      WillPopScope(
        onWillPop: onWillPop ?? () => Future.value(true),
        child: Dialog(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RegularSize.m)),
          insetPadding: EdgeInsets.symmetric(
            horizontal: (Get.width - width) / 2,
            vertical: (Get.height - (height ?? Get.height)) / 2,
          ),
          child: ConstrainedBox(
            // constraints: BoxConstraints(
            //   maxHeight: Get.height - (Get.height - (height ?? Get.height)) - (padding ?? EdgeInsets.all(RegularSize.m)).vertical * 2,
            // ),
            constraints: BoxConstraints(),
            child: Column(
              mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Container(
                  padding: padding ?? EdgeInsets.all(RegularSize.m),
                  alignment: alignment,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: dismissable,
    );
  }
}
