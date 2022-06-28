// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';

class RegularTimePicker {
  RegularTimePicker({this.initialTime});
  TimeOfDay? initialTime;

  Future<TimeOfDay?> show() {
    return showTimePicker(
      context: Get.context!,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, widget) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: RegularColor.primary,
              onSurface: RegularColor.dark,
            ),
            // button colors
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: RegularColor.primary,
              ),
            ),
          ),
          child: widget!,
        );
      },
    );
  }
}
