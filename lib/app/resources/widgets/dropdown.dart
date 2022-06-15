// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/keyboard_state_controller.dart';
import 'package:ventes/constants/regular_size.dart';

abstract class DropdownController<K, V> extends GetxController with GetSingleTickerProviderStateMixin {
  double get maxHeight => 200;

  final LayerLink layerLink = LayerLink();
  late OverlayEntry overlayEntry;
  late AnimationController animationController;
  late Animation<double> expandAnimation;

  GlobalKey buttonWidgetKey = GlobalKey();
  late BuildContext context;

  bool isMultiple = false;
  bool nullable = true;
  final rxIsOpen = false.obs;
  final rxSelectedKeys = Rx<List<K>>([]);
  final Rx<List<V>> rxItem = Rx<List<V>>([]);
  final Rx<bool> rxkeyboardIsOpen = Rx<bool>(false);

  Function(dynamic selectedKeys)? onChange;
  Widget Function(V, bool)? itemBuilder;

  List<V> get items => rxItem.value;
  set items(List<V> value) => rxItem.value = value;

  bool get isOpen => rxIsOpen.value;
  set isOpen(bool value) => rxIsOpen.value = value;

  bool get keyboardIsOpen => rxkeyboardIsOpen.value;
  set keyboardIsOpen(bool value) => rxkeyboardIsOpen.value = value;

  List<K> get selectedKeys => rxSelectedKeys.value;
  set selectedKeys(List<K> value) => rxSelectedKeys.value = value;
  K? get firstSelectedKey => selectedKeys.isNotEmpty ? rxSelectedKeys.value.first : null;

  @override
  void onInit() {
    super.onInit();
    Get.find<KeyboardStateController>().add(_onKeyboardChanged);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    expandAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    Get.find<KeyboardStateController>().remove(_onKeyboardChanged);
    super.dispose();
  }

  _onKeyboardChanged(bool visible) {
    keyboardIsOpen = visible;
  }

  reset() {
    selectedKeys = [];
    items = [];
  }

  void toggleDropdown({bool close = false}) async {
    OverlayState? overlay = Overlay.of(context);
    if (isOpen || close) {
      await animationController.reverse();
      overlayEntry.remove();
      isOpen = false;
    } else {
      overlayEntry = createOverlayEntry();
      overlay?.insert(overlayEntry);
      isOpen = true;
      animationController.forward();
    }
  }

  Widget get widget;

  OverlayEntry createOverlayEntry() {
    RenderBox renderBox = buttonWidgetKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () => toggleDropdown(close: true),
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: [
                Obx(() {
                  double keyboardInsets = 0;

                  if (keyboardIsOpen) {
                    keyboardInsets = MediaQuery.of(Get.context!).viewInsets.bottom;
                  }

                  var offset = renderBox.localToGlobal(Offset.zero);

                  var topOffset = offset.dy + 5;

                  double bottomMaxHeight = MediaQuery.of(context).size.height - topOffset - 15;
                  bool isTop = bottomMaxHeight - keyboardInsets < 200;

                  double keyboardDy = MediaQuery.of(context).size.height - keyboardInsets;
                  double marginBottom = 0;

                  if (isTop && offset.dy > keyboardDy) {
                    marginBottom = offset.dy - keyboardDy;
                  }

                  return Positioned(
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
                            sizeFactor: expandAnimation,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: maxHeight,
                              ),
                              child: widget,
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
