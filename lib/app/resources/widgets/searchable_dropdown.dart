// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/border_input.dart';
import 'package:ventes/app/states/controllers/keyboard_state_controller.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/styles/behavior_style.dart';

class SearchableDropdownController<T> extends GetxController with GetSingleTickerProviderStateMixin {
  final double maxHeight = 200;

  final LayerLink layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  GlobalKey buttonWidgetKey = GlobalKey();
  late BuildContext context;

  final TextEditingController _searchTEC = TextEditingController();
  Timer? _debounce;

  bool isMultiple = false;
  bool nullable = true;
  final _isOpen = false.obs;
  final _isLoading = false.obs;
  final _selectedItem = Rx<List<T>>([]);
  final Rx<List<DropdownItem<T>>> _items = Rx<List<DropdownItem<T>>>([]);
  final Rx<bool> _keyboardIsOpen = Rx<bool>(false);

  late Future<List<T>> Function(String?) onItemFilter;
  Function(dynamic selectedItem)? onChange;
  late bool Function(dynamic selectedItem, T item) onCompare;
  Widget Function(DropdownItem<T>, bool)? itemBuilder;

  List<DropdownItem<T>> get items => _items.value;
  set items(List<DropdownItem<T>> value) => _items.value = value;

  bool get isOpen => _isOpen.value;
  set isOpen(bool value) => _isOpen.value = value;

  bool get keyboardIsOpen => _keyboardIsOpen.value;
  set keyboardIsOpen(bool value) => _keyboardIsOpen.value = value;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  List<T> get selectedItem => _selectedItem.value;
  set selectedItem(List<T> value) => _selectedItem.value = value;
  T? get firstSelectedItem => selectedItem.isNotEmpty ? _selectedItem.value.first : null;

  @override
  void onInit() {
    super.onInit();
    Get.find<KeyboardStateController>().add(_onKeyboardChanged);
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _searchTEC.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _animationController.dispose();
    Get.find<KeyboardStateController>().remove(_onKeyboardChanged);
    super.dispose();
  }

  _onKeyboardChanged(bool visible) {
    keyboardIsOpen = visible;
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _itemFilter);
  }

  _itemFilter() async {
    isLoading = true;
    List<T> newItems = await onItemFilter(_searchTEC.text);
    items = newItems.map<DropdownItem<T>>((item) => DropdownItem(value: item)).toList();
    if (selectedItem.isEmpty && !nullable) {
      selectedItem = newItems.isNotEmpty ? [newItems.first] : [];

      dynamic selectedValue = isMultiple ? selectedItem : firstSelectedItem;
      if (isMultiple) {
        onChange?.call(items.where((item) => onCompare(selectedValue, item.value)).toList());
      } else {
        onChange?.call(firstSelectedItem == null ? null : items.firstWhere((item) => onCompare(selectedValue, item.value)));
      }
    }
    isLoading = false;
  }

  void toggleDropdown({bool close = false}) async {
    OverlayState? overlay = Overlay.of(context);
    if (isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      isOpen = false;
    } else {
      _overlayEntry = createOverlayEntry();
      overlay?.insert(_overlayEntry);
      isOpen = true;
      _animationController.forward();
    }
  }

  OverlayEntry createOverlayEntry() {
    BorderInput searchField = BorderInput(
      hintText: "Search",
      controller: _searchTEC,
    );

    RenderBox renderBox = buttonWidgetKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () => toggleDropdown(close: true),
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Obx(() {
                  double keyboardInsets = 0;

                  if (keyboardIsOpen) {
                    keyboardInsets = MediaQuery.of(Get.context!).viewInsets.bottom;
                  }

                  var offset = renderBox.localToGlobal(Offset.zero);

                  var topOffset = offset.dy + 5;
                  var bottomOffset = MediaQuery.of(context).size.height - (offset.dy - 5);

                  double bottomMaxHeight = MediaQuery.of(context).size.height - topOffset - 15;
                  bool isTop = bottomMaxHeight - keyboardInsets < 200;

                  double keyboardDy = MediaQuery.of(context).size.height - keyboardInsets;
                  double marginBottom = 0;

                  if (isTop && offset.dy > keyboardDy) {
                    marginBottom = offset.dy - keyboardDy;
                    bottomOffset = bottomOffset + marginBottom;
                  }

                  return Positioned(
                    left: offset.dx,
                    top: !isTop ? topOffset : null,
                    bottom: isTop ? bottomOffset : null,
                    width: size.width,
                    child: CompositedTransformFollower(
                      offset: Offset(0, !isTop ? 5 : -5 - marginBottom),
                      link: layerLink,
                      showWhenUnlinked: false,
                      followerAnchor: isTop ? Alignment.bottomCenter : Alignment.topCenter,
                      targetAnchor: isTop ? Alignment.topCenter : Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(RegularSize.m),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0157E4).withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 30,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          child: SizeTransition(
                            axisAlignment: 1,
                            sizeFactor: _expandAnimation,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: maxHeight,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: RegularSize.s,
                                    ),
                                    child: searchField,
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
                                                    DropdownItem<T> item = items[index];

                                                    dynamic selectedValue = isMultiple ? selectedItem : firstSelectedItem;
                                                    bool isSelected = onCompare(selectedValue, item.value);

                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (isMultiple) {
                                                          if (isSelected) {
                                                            if (nullable) {
                                                              _selectedItem.update((val) {
                                                                val?.removeWhere((element) => onCompare(selectedValue, element));
                                                              });
                                                            }
                                                          } else {
                                                            selectedItem = [...selectedItem, item.value];
                                                          }
                                                          onChange?.call(items.where((item) => onCompare(selectedValue, item.value)).toList());
                                                        } else {
                                                          if (isSelected) {
                                                            if (nullable) {
                                                              selectedItem = [];
                                                            }
                                                          } else {
                                                            selectedItem = [item.value];
                                                          }
                                                          onChange?.call(firstSelectedItem == null ? null : items.firstWhere((item) => onCompare(selectedItem, item.value)));
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchableDropdown<T> extends StatelessWidget {
  final Widget child;

  double? width;
  double? height;
  SearchableDropdownController<T> controller;

  ///
  /// If isMultiple is true, selectedItem is a list of selected items
  /// If isMultiple is false, selectedItem is a single selected item
  ///
  dynamic selectedKey;

  ///
  /// If isMultiple is true, selectedItem parameter is a list of selected items
  /// If isMultiple is false, selectedItem parameter is a single selected item
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
    Widget Function(DropdownItem<T>, bool)? itemBuilder,
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

class DropdownItem<T> {
  final T value;
  final Widget? child;

  DropdownItem({required this.value, this.child});
}
