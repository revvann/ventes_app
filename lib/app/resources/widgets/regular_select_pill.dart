// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularSelectPill extends StatelessWidget {
  List<RegularSelectPillItem> items;
  void Function(String value) onSelected;
  var activeValue = Rx<String?>(null);
  String label;

  RegularSelectPill({
    required this.items,
    required this.onSelected,
    required this.label,
  }) {
    activeValue.value = items.first.value;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: RegularColor.primary,
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Row(
          children: [
            for (int index = 0; index < items.length; index++)
              Container(
                margin: EdgeInsets.only(left: RegularSize.xs),
                child: GestureDetector(
                  child: Obx(() {
                    return RegularSelectPillItem(
                      text: items[index].text,
                      value: items[index].value,
                      isActive: activeValue.value == items[index].value,
                    );
                  }),
                  onTap: () {
                    onSelected(items[index].value);
                    activeValue.value = items[index].value;
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class RegularSelectPillItem extends StatelessWidget {
  String text;
  String value;
  bool isActive;

  RegularSelectPillItem({
    required this.text,
    required this.value,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: RegularColor.primary,
          width: 2,
        ),
        color: isActive ? RegularColor.primary : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isActive ? Colors.white : RegularColor.primary,
        ),
      ),
    );
  }
}
