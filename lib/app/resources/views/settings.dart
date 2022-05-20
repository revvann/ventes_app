// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/app/states/controllers/settings_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/styles/behavior_style.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/view.dart';

class SettingsView extends View<SettingsStateController> {
  static const String route = "/settings";
  final CustomDropdownController<int> _customDropdownController = Get.put(CustomDropdownController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              CustomDropdown<int>(
                controller: _customDropdownController,
                child: RegularInput(
                  enabled: false,
                  hintText: "Country",
                ),
                onChange: (int value) => print(value),
                dropdownButtonStyle: DropdownButtonStyle(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 6,
                  padding: EdgeInsets.all(5),
                ),
                items: [
                  for (int i = 0; i < 20; i++)
                    DropdownItem(
                      value: i,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: RegularSize.s,
                          vertical: RegularSize.s,
                        ),
                        child: Text(
                          "Country $i",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                child: Text('SUBMIT'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdownController<T> extends GetxController with GetSingleTickerProviderStateMixin {
  final LayerLink layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  GlobalKey buttonWidgetKey = GlobalKey();
  late BuildContext context;

  final _isOpen = false.obs;
  final _currentIndex = Rx<int>(-1);
  final Rx<List<DropdownItem<T>>> _items = Rx<List<DropdownItem<T>>>([]);

  Function(T)? onChange;
  late OverlayEntry Function() overlayBuilder;

  List<DropdownItem<T>> get items => _items.value;
  set items(List<DropdownItem<T>> value) => _items.value = value;

  bool get isOpen => _isOpen.value;
  set isOpen(bool value) => _isOpen.value = value;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

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
      _overlayEntry = overlayBuilder();
      overlay?.insert(_overlayEntry);
      isOpen = true;
      _animationController.forward();
    }
  }

  OverlayEntry createOverlayEntry(DropdownStyle dropdownStyle) {
    RenderBox renderBox = buttonWidgetKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      builder: (context) {
        double maxHeight = MediaQuery.of(context).size.height - topOffset - 15;
        if (maxHeight > 200) maxHeight = 200;

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
                  top: topOffset,
                  width: dropdownStyle.width ?? size.width,
                  child: CompositedTransformFollower(
                    offset: dropdownStyle.offset ?? Offset(0, size.height + 5),
                    link: layerLink,
                    showWhenUnlinked: false,
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
                                  padding: EdgeInsets.all(RegularSize.s),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    DropdownItem<T> item = items[index];
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(RegularSize.s),
                                      focusColor: RegularColor.green.withOpacity(0.1),
                                      splashColor: RegularColor.green.withOpacity(0.1),
                                      highlightColor: RegularColor.green.withOpacity(0.1),
                                      onTap: () {
                                        currentIndex = index;
                                        onChange?.call(item.value);
                                        toggleDropdown();
                                      },
                                      child: item,
                                    );
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

class CustomDropdown<T> extends StatelessWidget {
  final Widget child;

  final void Function(T)? onChange;

  final List<DropdownItem<T>> items;
  final DropdownStyle dropdownStyle;

  final DropdownButtonStyle dropdownButtonStyle;

  CustomDropdownController<T> controller;

  CustomDropdown({
    required this.child,
    required this.items,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    required this.onChange,
    required this.controller,
  }) {
    controller.items = items;
    controller.onChange = onChange;
    controller.overlayBuilder = () => controller.createOverlayEntry(dropdownStyle);
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return CompositedTransformTarget(
      link: controller.layerLink,
      child: SizedBox(
        width: dropdownButtonStyle.width,
        height: dropdownButtonStyle.height,
        child: GestureDetector(
          key: controller.buttonWidgetKey,
          onTap: controller.toggleDropdown,
          child: child,
        ),
      ),
    );
  }
}

class DropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const DropdownItem({Key? key, required this.value, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? primaryColor;
  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  final Offset? offset;

  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}
