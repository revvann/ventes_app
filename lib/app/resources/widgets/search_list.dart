// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'dart:async';

class SearchList<T, V> {
  SearchList({
    required this.onFilter,
    required this.itemBuilder,
    this.onItemSelected,
    this.compare,
    required this.controller,
  });
  Widget Function(T item, V? selectedItem) itemBuilder;
  Future Function(String?) onFilter;
  void Function(V?)? onItemSelected;
  bool Function(T, V?)? compare;
  SearchListController<T, V> controller;

  show() {
    RegularBottomSheet(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: Get.height * 0.5,
        width: Get.width,
        child: SearchListWidget<T, V>(
          controller: controller,
          itemBuilder: itemBuilder,
          onFilter: onFilter,
          onItemSelected: onItemSelected,
          compare: compare,
        ),
      ),
    ).show();
  }
}

class SearchListController<T, V> extends GetxController {
  ///
  /// Function for build list item after data loaded
  ///
  late Widget Function(T item, V? selectedItem) itemBuilder;

  ///
  /// Function for load data from server,
  ///
  late Future Function(String?) onFilter;

  ///
  /// Trigger when item was selected or unselected (multiple options)
  ///
  void Function(V?)? onItemSelected;

  ///
  /// Function for compare item to selectedItem when build list item widget
  /// default to be use == operator
  ///
  bool Function(T item, V? selectedItem)? compare;

  final Rx<V?> _selectedItem = Rx<V?>(null);
  V? get selectedItem => _selectedItem.value;
  set selectedItem(V? value) => _selectedItem.value = value;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  final _items = <T>[].obs;
  List<T> get items => _items.value;
  set items(List<T> value) => _items.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _rebuildList(query);
    });
  }

  _rebuildList([String? search]) async {
    isLoading = true;
    List<T> items = await onFilter(search);
    isLoading = false;
    this.items = items;
  }

  bool _isMultiple() {
    return V is List<T>?;
  }

  void setSelectedItem(T item) {
    bool isSelected = compare?.call(item, selectedItem) ?? false;
    if (_isMultiple()) {
      List<T> selectedItems = selectedItem as List<T>;
      if (isSelected) {
        selectedItems.removeWhere((element) => compare?.call(element, selectedItem) ?? false);
      } else {
        selectedItems.add(item);
      }
    } else {
      if (isSelected) {
        selectedItem = null;
      } else {
        selectedItem = item as V?;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (V is List<T>?) {
      selectedItem = <T>[] as V;
    }

    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

class SearchListWidget<T, V> extends StatelessWidget {
  SearchListWidget({
    required this.controller,
    required Future Function(String?) onFilter,
    required Widget Function(T item, V? selectedItem) itemBuilder,
    void Function(V?)? onItemSelected,
    bool Function(T item, V? selectedItem)? compare,
  }) {
    controller.compare ??= (T i1, V? i2) => i1 == i2;
    controller.onFilter = onFilter;
    controller.itemBuilder = itemBuilder;
    controller.onItemSelected = onItemSelected;
    controller._rebuildList();
  }

  final SearchListController<T, V> controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconInput(
          icon: "assets/svg/search.svg",
          hintText: "Search",
          controller: controller._searchController,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return controller.items.isEmpty && !controller.isLoading
              ? Text(
                  "Item not found",
                  style: TextStyle(
                    color: RegularColor.dark,
                    fontSize: 16,
                  ),
                )
              : Container();
        }),
        Obx(() {
          return controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container();
        }),
        Expanded(child: Obx(() {
          return ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (__, index) {
              T item = controller.items[index];
              return GestureDetector(
                child: Obx(() {
                  return controller.itemBuilder(item, controller.selectedItem);
                }),
                onTap: () {
                  controller.setSelectedItem(item);
                  controller.onItemSelected?.call(controller.selectedItem);
                },
              );
            },
          );
        })),
      ],
    );
  }
}
