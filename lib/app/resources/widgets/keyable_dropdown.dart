// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/styles/behavior_style.dart';

class KeyableDropdownController<K, V> extends GetxController with GetSingleTickerProviderStateMixin {
  final double maxHeight = 200;

  final LayerLink layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  GlobalKey buttonWidgetKey = GlobalKey();
  late BuildContext context;

  bool isMultiple = false;
  final _isOpen = false.obs;
  final _selectedItem = Rx<List<K>>([]);
  final Rx<List<DropdownItem<K, V>>> _items = Rx<List<DropdownItem<K, V>>>([]);

  Function(dynamic selectedItem)? onChange;
  Widget Function(DropdownItem<K, V>, bool)? itemBuilder;

  List<DropdownItem<K, V>> get items => _items.value;
  set items(List<DropdownItem<K, V>> value) => _items.value = value;

  bool get isOpen => _isOpen.value;
  set isOpen(bool value) => _isOpen.value = value;

  List<K> get selectedItem => _selectedItem.value;
  set selectedItem(List<K> value) => _selectedItem.value = value;
  K? get firstSelectedItem => selectedItem.isNotEmpty ? _selectedItem.value.first : null;

  @override
  void onInit() {
    super.onInit();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
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
    RenderBox renderBox = buttonWidgetKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        var offset = renderBox.localToGlobal(Offset.zero);

        var topOffset = offset.dy + 5;
        var bottomOffset = MediaQuery.of(context).size.height - (offset.dy - 5);

        double bottomMaxHeight = MediaQuery.of(context).size.height - topOffset - 15;
        bool isTop = bottomMaxHeight < 200;

        return GestureDetector(
          onTap: () => toggleDropdown(close: true),
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: offset.dx,
                  top: !isTop ? topOffset : null,
                  bottom: isTop ? bottomOffset : null,
                  width: size.width,
                  child: CompositedTransformFollower(
                    offset: Offset(0, !isTop ? 5 : -5),
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
                            child: Obx(() {
                              return ScrollConfiguration(
                                behavior: BehaviorStyle(),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(RegularSize.s),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return Obx(() {
                                      DropdownItem<K, V> item = items[index];

                                      bool isSelected;
                                      if (isMultiple) {
                                        isSelected = selectedItem.contains(item.key);
                                      } else {
                                        isSelected = firstSelectedItem == item.key;
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          if (isMultiple) {
                                            if (isSelected) {
                                              _selectedItem.update((val) {
                                                val?.remove(item.key);
                                              });
                                            } else {
                                              selectedItem = [...selectedItem, item.key];
                                            }
                                            onChange?.call(items.where((item) => selectedItem.contains(item.key)).toList());
                                          } else {
                                            if (isSelected) {
                                              selectedItem = [];
                                            } else {
                                              selectedItem = [item.key];
                                            }
                                            onChange?.call(firstSelectedItem == null ? null : items.firstWhere((item) => item.key == firstSelectedItem));
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KeyableDropdown<K, V> extends StatelessWidget {
  final Widget child;

  double? width;
  double? height;
  KeyableDropdownController<K, V> controller;

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

  KeyableDropdown({
    required this.child,
    required List<DropdownItem<K, V>> items,
    required this.controller,
    this.width,
    this.height,
    this.onChange,
    bool isMultiple = false,
    Widget Function(DropdownItem<K, V>, bool)? itemBuilder,
    this.selectedKey,
  }) {
    controller.items = items;
    controller.onChange = onChange;
    controller.itemBuilder = itemBuilder;
    controller.isMultiple = isMultiple;

    if (selectedKey is K) {
      controller.selectedItem = [selectedKey];
    } else if (selectedKey is List<K>) {
      controller.selectedItem = selectedKey;
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

class DropdownItem<K, V> {
  final K key;
  final V value;
  final Widget? child;

  DropdownItem({required this.key, required this.value, this.child});
}
