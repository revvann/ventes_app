// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class KeyableSelectBar<K> extends StatelessWidget {
  String? label;
  final _activeIndex = Rx<K?>(null);
  void Function(K)? onSelected;
  Map<K, String> items;
  double? height;
  double? width;

  KeyableSelectBar({
    this.label,
    this.onSelected,
    this.items = const {},
    K? activeIndex,
    this.height,
    this.width,
  }) {
    if (activeIndex != null) {
      _activeIndex.value = activeIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label ?? "",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: RegularColor.dark,
              ),
            ),
          SizedBox(
            height: RegularSize.s,
          ),
          Container(
            width: double.infinity,
            height: height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.keys.length,
              itemBuilder: (_, index) {
                K key = items.keys.elementAt(index);
                String value = items[key]!;
                return Obx(() {
                  return _buildItem(
                    height,
                    value,
                    _activeIndex.value == key,
                    () {
                      bool isSame = _activeIndex.value == key;
                      if (!isSame) {
                        _activeIndex.value = key;
                        onSelected?.call(key);
                      }
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(double? height, String text, bool isActive, void Function() onTap) {
    double width = text.length * 10 + 10;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: RegularSize.xs),
      child: Material(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RegularSize.s),
          splashColor: isActive ? RegularColor.green.withOpacity(0.1) : null,
          child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isActive ? RegularColor.green : Colors.white,
              border: Border.all(
                color: isActive ? RegularColor.green : RegularColor.disable,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(RegularSize.s),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: isActive ? Colors.white : RegularColor.dark,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
