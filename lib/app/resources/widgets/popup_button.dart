// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_size.dart';

class PopupMenuController<K, V> extends GetxController with GetSingleTickerProviderStateMixin {
  late DropdownSettings dropdownSettings;

  final LayerLink layerLink = LayerLink();
  late OverlayEntry overlayEntry;
  late AnimationController animationController;
  late Animation<double> expandAnimation;

  late BuildContext context;

  final rxIsOpen = false.obs;

  bool get isOpen => rxIsOpen.value;
  set isOpen(bool value) => rxIsOpen.value = value;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    expandAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

  OverlayEntry createOverlayEntry() {
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
                Positioned(
                  width: dropdownSettings.width,
                  height: dropdownSettings.height,
                  child: CompositedTransformFollower(
                    offset: dropdownSettings.offset ?? Offset.zero,
                    link: layerLink,
                    showWhenUnlinked: false,
                    followerAnchor: Alignment.topRight,
                    targetAnchor: Alignment.bottomLeft,
                    child: FadeTransition(
                      opacity: expandAnimation,
                      child: Container(
                        width: dropdownSettings.width,
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: dropdownSettings.maxHeight ?? double.infinity,
                              maxWidth: dropdownSettings.maxWidth ?? double.infinity,
                            ),
                            child: dropdownSettings.child,
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

class PopupMenu<K, V> extends StatelessWidget {
  final Widget child;

  double? width;
  double? height;
  DropdownSettings dropdownSettings;
  PopupMenuController<K, V> controller;

  PopupMenu({
    required this.child,
    required this.controller,
    this.width,
    this.height,
    this.dropdownSettings = const DropdownSettings(),
  }) {
    controller.dropdownSettings = dropdownSettings;
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
          onTap: controller.toggleDropdown,
          child: child,
        ),
      ),
    );
  }
}

class DropdownSettings {
  final double? width;
  final double? height;
  final double? maxHeight;
  final double? maxWidth;
  final Offset? offset;
  final Widget? child;

  const DropdownSettings({
    this.width = 200,
    this.height,
    this.maxHeight = 200,
    this.maxWidth,
    this.offset = const Offset(0, 5),
    this.child,
  });
}
