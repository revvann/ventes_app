// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularDropdown<T> extends StatelessWidget {
  RegularDropdown({
    Key? key,
    List? items,
    value,
    DropdownController<T>? controller,
    this.label,
    this.onSelected,
    this.icon,
  }) : super(key: key) {
    if (controller != null) {
      this.controller = controller;
    } else {
      this.controller = DropdownController(value);
    }

    if (value != null) {
      this.controller.value = value;
    }
    if (items != null) {
      this.controller.items = items;
    }
  }
  late DropdownController controller;
  String? label;
  void Function(T)? onSelected;
  String? icon;

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
        SizedBox(
          height: RegularSize.xs,
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
          child: Row(
            children: [
              if (icon != null)
                SizedBox(
                  width: RegularSize.s,
                ),
              if (icon != null)
                Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    icon ?? "",
                    color: RegularColor.green,
                    width: RegularSize.m,
                  ),
                ),
              if (icon != null)
                SizedBox(
                  width: RegularSize.s,
                ),
              Obx(() {
                return Expanded(
                  child: DropdownButton<T>(
                    style: TextStyle(
                      fontSize: 16,
                      color: RegularColor.dark,
                    ),
                    icon: SizedBox(),
                    elevation: 1,
                    menuMaxHeight: 200,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    value: controller.value,
                    isDense: true,
                    underline: SizedBox(),
                    items: [
                      for (var item in controller.items)
                        DropdownMenuItem<T>(
                          onTap: () {},
                          child: Text(item["text"]),
                          value: item["value"],
                        ),
                    ],
                    onChanged: controller.enabled
                        ? (value) {
                            controller.value = value;
                            onSelected?.call(value!);
                          }
                        : null,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class DropdownController<T> {
  DropdownController(value) {
    _value = Rx<T>(value);
  }

  final Rx<List> _items = Rx<List>([]);
  List get items => _items.value;
  set items(List value) => _items.value = value;

  final Rx<bool> _enabled = Rx<bool>(true);
  bool get enabled => _enabled.value;
  set enabled(bool value) => _enabled.value = value;

  late final Rx<T> _value;
  T get value => _value.value;
  set value(T value) => _value.value = value;
}
