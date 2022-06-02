// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/border_input.dart';
import 'package:ventes/app/resources/widgets/dropdown.dart';
import 'package:ventes/app/states/controllers/keyboard_state_controller.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/styles/behavior_style.dart';

class SearchableDropdownController<T> extends DropdownController<T, SearchableDropdownItem<T>> {
  final TextEditingController _searchTEC = TextEditingController();
  Timer? _debounce;

  final _isLoading = false.obs;

  late Future<List<T>> Function(String?) onItemFilter;
  late bool Function(dynamic selectedKeys, T item) onCompare;

  late BorderInput _searchInput;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  @override
  void onInit() {
    super.onInit();
    _searchInput = BorderInput(
      hintText: "Search",
      controller: _searchTEC,
    );
    _searchTEC.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _itemFilter);
  }

  _itemFilter() async {
    isLoading = true;
    List<T> newItems = await onItemFilter(_searchTEC.text);
    items = newItems.map<SearchableDropdownItem<T>>((item) => SearchableDropdownItem<T>(value: item)).toList();
    if (selectedKeys.isEmpty && !nullable) {
      selectedKeys = newItems.isNotEmpty ? [newItems.first] : [];

      dynamic selectedValue = isMultiple ? selectedKeys : firstSelectedKey;
      if (isMultiple) {
        onChange?.call(items.where((item) => onCompare(selectedValue, item.value)).toList());
      } else {
        onChange?.call(firstSelectedKey == null ? null : items.firstWhere((item) => onCompare(selectedValue, item.value)));
      }
    }
    isLoading = false;
  }

  @override
  reset() {
    super.reset();
    _itemFilter();
  }

  @override
  Widget get widget => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RegularSize.s,
            ),
            child: _searchInput,
          ),
          SizedBox(height: RegularSize.xs),
          Expanded(
            child: Obx(() {
              return ScrollConfiguration(
                behavior: BehaviorStyle(),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(RegularSize.s),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Obx(() {
                            SearchableDropdownItem<T> item = items[index];

                            dynamic selectedValue = isMultiple ? selectedKeys : firstSelectedKey;
                            bool isSelected = onCompare(selectedValue, item.value);

                            return GestureDetector(
                              onTap: () {
                                if (isMultiple) {
                                  if (isSelected) {
                                    if (nullable) {
                                      rxSelectedKeys.update((val) {
                                        val?.removeWhere((element) => onCompare(selectedValue, element));
                                      });
                                    }
                                  } else {
                                    selectedKeys = [...selectedKeys, item.value];
                                  }
                                  selectedValue = isMultiple ? selectedKeys : firstSelectedKey;
                                  onChange?.call(items.where((item) => onCompare(selectedValue, item.value)).toList());
                                } else {
                                  if (isSelected) {
                                    if (nullable) {
                                      selectedKeys = [];
                                    }
                                  } else {
                                    selectedKeys = [item.value];
                                  }
                                  selectedValue = isMultiple ? selectedKeys : firstSelectedKey;
                                  onChange?.call(firstSelectedKey == null ? null : items.firstWhere((item) => onCompare(selectedValue, item.value)));
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
            }),
          ),
        ],
      );
}

class SearchableDropdown<T> extends StatelessWidget {
  final Widget child;

  double? width;
  double? height;
  SearchableDropdownController<T> controller;

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

  SearchableDropdown({
    required this.child,
    required this.controller,
    this.width,
    this.height,
    this.onChange,
    bool isMultiple = false,
    bool nullable = true,
    Widget Function(SearchableDropdownItem<T>, bool)? itemBuilder,
    this.selectedKey,
    required Future<List<T>> Function(String?) onItemFilter,
    required bool Function(dynamic selectedItem, T item) onCompare,
  }) {
    controller.onChange = onChange;
    controller.itemBuilder = itemBuilder;
    controller.isMultiple = isMultiple;
    controller.nullable = nullable;
    controller.onItemFilter = onItemFilter;
    controller.onCompare = onCompare;
    controller._itemFilter();
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

class SearchableDropdownItem<T> {
  final T value;
  final Widget? child;

  SearchableDropdownItem({required this.value, this.child});
}
