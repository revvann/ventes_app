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
  });
  GlobalKey? appBarKey;
  Widget? leading;
  String title;
  List<Widget>? actions;

  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      key: appBarKey,
      toolbarHeight: 60,
      centerTitle: true,
      backgroundColor: RegularColor.primary,
      elevation: 0,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: actions,
    );
  }
}
