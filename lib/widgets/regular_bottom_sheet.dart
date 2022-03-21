// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularBottomSheet {
  RegularBottomSheet({
    required this.child,
    this.title,
    this.backgroundColor,
  });

  Widget child;
  String? title;
  Color? backgroundColor;

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
                  RegularSize.m,
                ),
                topRight: Radius.circular(
                  RegularSize.m,
                ),
              ),
            ),
            child: child,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
