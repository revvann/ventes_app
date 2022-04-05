// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/widgets/regular_button.dart';
import 'package:ventes/widgets/regular_dialog.dart';
import 'package:ventes/widgets/regular_outlined_button.dart';

class RegularDatePicker {
  RegularDatePicker({
    required this.onSelected,
    this.initialdate,
    this.minDate,
    this.maxDate,
  }) {
    date = initialdate;
  }
  void Function(DateTime? date) onSelected;
  DateTime? initialdate;
  DateTime? date;
  DateTime? minDate;
  DateTime? maxDate;

  Future show() {
    return RegularDialog(
      width: Get.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  "Choose Date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: RegularColor.dark,
                  ),
                ),
                SfDateRangePicker(
                  initialSelectedDate: initialdate,
                  minDate: minDate,
                  maxDate: maxDate,
                  view: DateRangePickerView.month,
                  allowViewNavigation: false,
                  headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: RegularColor.dark,
                    ),
                  ),
                  onSelectionChanged: (date) {
                    this.date = date.value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: RegularOutlinedButton(
                        label: "Cancel",
                        height: RegularSize.xxl,
                        onPressed: () {
                          Get.close(1);
                        },
                      ),
                    ),
                    SizedBox(
                      width: RegularSize.m,
                    ),
                    Expanded(
                      child: RegularButton(
                        label: "Choose",
                        height: RegularSize.xxl,
                        onPressed: () {
                          onSelected.call(date);
                          Get.close(1);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).show();
  }
}
