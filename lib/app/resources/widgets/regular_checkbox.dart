// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularCheckbox extends StatelessWidget {
  RegularCheckbox({
    Key? key,
    required this.label,
    bool value = false,
    this.onChecked,
    this.enabled = true,
  }) {
    this.value = Rx<bool>(value);
  }
  String label;
  late Rx<bool> value;
  void Function(bool value)? onChecked;
  bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enabled) {
          value.value = !value.value;
          onChecked?.call(value.value);
        }
      },
      child: Row(
        children: [
          Container(
            width: RegularSize.m,
            height: RegularSize.m,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(
                color: RegularColor.green,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Obx(() {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: value.value ? RegularColor.green : Colors.white,
                ),
              );
            }),
          ),
          SizedBox(
            width: RegularSize.xs,
          ),
          Text(
            label,
            style: TextStyle(
              color: enabled ? RegularColor.dark : RegularColor.gray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
