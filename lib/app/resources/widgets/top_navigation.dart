// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class TopNavigation {
  TopNavigation({
    this.appBarKey,
    this.leading,
    required this.title,
    this.actions,
    this.height = 60,
    this.below,
  });
  GlobalKey? appBarKey;
  Widget? leading;
  String title;
  List<Widget>? actions;
  double height;
  Widget? below;

  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      key: appBarKey,
      toolbarHeight: height,
      backgroundColor: RegularColor.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Column(
        children: [
          SizedBox(
            height: RegularSize.xl,
          ),
          Row(
            children: [
              SizedBox(
                width: RegularSize.s,
              ),
              Container(
                width: 75,
                alignment: Alignment.centerLeft,
                child: leading,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions ?? [],
                ),
              ),
              SizedBox(
                width: RegularSize.s,
              ),
            ],
          ),
          below ?? Container(),
        ],
      ),
    );
  }
}
