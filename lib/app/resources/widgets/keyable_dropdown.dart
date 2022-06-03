// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/dropdown.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/styles/behavior_style.dart';

class KeyableDropdownController<K, V> extends DropdownController<K, KeyableDropdownItem<K, V>> {
  @override
  Widget get widget => Obx(() {
        return ScrollConfiguration(
          behavior: BehaviorStyle(),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(RegularSize.s),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Obx(() {
                KeyableDropdownItem<K, V> item = items[index];

                bool isSelected;
                if (isMultiple) {
                  isSelected = selectedKeys.contains(item.key);
                } else {
                  isSelected = firstSelectedKey == item.key;
                }

                return GestureDetector(
                  onTap: () {
                    if (isMultiple) {
                      if (isSelected) {
                        if (nullable) {
                          rxSelectedKeys.update((val) {
                            val?.remove(item.key);
                          });
                        }
                      } else {
                        selectedKeys = [...selectedKeys, item.key];
                      }
                      onChange?.call(items.where((item) => selectedKeys.contains(item.key)).toList());
                    } else {
                      if (isSelected) {
                        if (nullable) {
                          selectedKeys = [];
                        }
                      } else {
                        selectedKeys = [item.key];
                      }
                      onChange?.call(firstSelectedKey == null ? null : items.firstWhere((item) => item.key == firstSelectedKey));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: item.child ?? itemBuilder!(item, isSelected),
                  ),
                );
              });
            },
          ),
        );
      });
}

class KeyableDropdown<K, V> extends StatelessWidget {
  final Widget child;

  double? width;
  double? height;
  KeyableDropdownController<K, V> controller;

  ///
  /// If isMultiple is true, selectedKeys is a list of selected items
  /// If isMultiple is false, selectedKeys is a single selected item
  ///
  dynamic selectedKey;

  ///
  /// If isMultiple is true, selectedKeys parameter is a list of selected items
  /// If isMultiple is false, selectedKeys parameter is a single selected item
  ///
  void Function(dynamic selectedItem)? onChange;

  KeyableDropdown({
    required this.child,
    required List<KeyableDropdownItem<K, V>> items,
    required this.controller,
    this.width,
    this.height,
    this.onChange,
    bool isMultiple = false,
    bool nullable = true,
    Widget Function(KeyableDropdownItem<K, V>, bool)? itemBuilder,
    this.selectedKey,
  }) {
    controller.items = items;
    controller.onChange = onChange;
    controller.itemBuilder = itemBuilder;
    controller.isMultiple = isMultiple;
    controller.nullable = nullable;

    if (selectedKey == null && !nullable && items.isNotEmpty) {
      selectedKey = items.first.key;
    }

    if (selectedKey is K) {
      controller.selectedKeys = [selectedKey];
    } else if (selectedKey is List<K>) {
      controller.selectedKeys = selectedKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return CompositedTransformTarget(
      link: controller.layerLink,
      child: SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          key: controller.buttonWidgetKey,
          onTap: controller.toggleDropdown,
          child: child,
        ),
      ),
    );
  }
}

class KeyableDropdownItem<K, V> {
  final K key;
  final V value;
  final Widget? child;

  KeyableDropdownItem({required this.key, required this.value, this.child});
}
