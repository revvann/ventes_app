// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularDropdown<T> extends StatelessWidget {
  RegularDropdown({
    Key? key,
    required this.items,
    value,
    this.enabled = true,
    DropdownController<T>? controller,
    this.label,
    this.onSelected,
  }) : super(key: key) {
    if (controller != null) {
      this.controller = controller;
    } else {
      this.controller = DropdownController(value);
    }

    if (value != null) {
      this.controller.value = value;
    } else {
      this.value = this.controller.value;
    }

    this.controller.addListener(() {
      this.value = this.controller.value;
    });
  }
  late DropdownController controller;
  String? label;
  void Function(T)? onSelected;
  List<Map> items;
  bool enabled;
  late Rx<T> value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: RegularColor.dark,
            ),
          ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: RegularSize.xs,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: RegularColor.gray.withAlpha(100),
              ),
            ),
          ),
          child: Obx(() {
            return DropdownButton<T>(
              style: TextStyle(
                fontSize: 14,
                color: RegularColor.dark,
              ),
              icon: SizedBox(),
              elevation: 1,
              menuMaxHeight: 200,
              isExpanded: true,
              dropdownColor: Colors.white,
              value: value.value,
              isDense: true,
              underline: SizedBox(),
              items: [
                for (var item in items)
                  DropdownMenuItem<T>(
                    onTap: () {},
                    child: Text(item["text"]),
                    value: item["value"],
                  ),
              ],
              onChanged: enabled
                  ? (value) {
                      controller.value = value;
                      onSelected?.call(value!);
                    }
                  : null,
            );
          }),
        ),
      ],
    );
  }
}

class DropdownController<T> extends ValueNotifier<T> {
  DropdownController(value) : super(value);
}
