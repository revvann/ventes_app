// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class KeyableSelectBar<K> extends StatelessWidget {
  String? label;
  final _activeIndex = Rx<List<K>>([]);
  void Function(dynamic)? onSelected;
  Map<K, String> items;
  double? height;
  double? width;
  bool isMultiple;
  bool nullable;

  KeyableSelectBar({
    this.label,
    this.onSelected,
    this.items = const {},
    dynamic activeIndex,
    this.height,
    this.width,
    this.isMultiple = false,
    this.nullable = true,
  }) {
    if (activeIndex == null && !nullable && items.isNotEmpty) {
      activeIndex = items.keys.first;
    }

    if (activeIndex is K) {
      this.activeIndex = [activeIndex];
    } else if (activeIndex is List<K>) {
      this.activeIndex = activeIndex;
    }
  }

  List<K> get activeIndex => _activeIndex.value;
  K? get firstActiveIndex => activeIndex.isNotEmpty ? activeIndex.first : null;
  set activeIndex(List<K> value) => _activeIndex.value = value;

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
                color: RegularColor.primary,
              ),
            ),
          SizedBox(
            height: RegularSize.s,
          ),
          SizedBox(
            width: double.infinity,
            height: height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: items.keys.length,
              itemBuilder: (_, index) {
                K key = items.keys.elementAt(index);
                String value = items[key]!;
                return Obx(() {
                  bool isSelected;
                  if (isMultiple) {
                    isSelected = activeIndex.contains(key);
                  } else {
                    isSelected = firstActiveIndex == key;
                  }
                  return _buildItem(
                    height,
                    value,
                    isSelected,
                    () {
                      if (isMultiple) {
                        _activeIndex.update((val) {
                          if (isSelected) {
                            if (nullable) {
                              val?.remove(key);
                            }
                          } else {
                            val?.add(key);
                          }
                        });
                        onSelected?.call(activeIndex);
                      } else {
                        if (isSelected) {
                          if (nullable) {
                            activeIndex = [];
                          }
                        } else {
                          activeIndex = [key];
                        }
                        onSelected?.call(firstActiveIndex);
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
