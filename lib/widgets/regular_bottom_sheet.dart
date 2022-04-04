// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularBottomSheet {
  RegularBottomSheet({
    required this.child,
    this.title,
    this.backgroundColor,
    this.enableDrag = true,
  });

  Widget child;
  String? title;
  Color? backgroundColor;
  bool enableDrag;

  Future show() {
    return Get.bottomSheet(
      Wrap(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: RegularSize.l,
              vertical: RegularSize.m,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  RegularSize.xl,
                ),
                topRight: Radius.circular(
                  RegularSize.xl,
                ),
              ),
            ),
            child: child,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      enableDrag: enableDrag,
    );
  }
}
