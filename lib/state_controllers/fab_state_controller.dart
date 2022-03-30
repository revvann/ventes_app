// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:ventes/constants/regular_size.dart';

class FABStateController extends GetxController with GetTickerProviderStateMixin {
  late Animation<MultiTweenValues<String>> fabPosition;
  late AnimationController fabController;

  final _isShown = false.obs;
  bool get isShown => _isShown.value;
  set isShown(value) => _isShown.value = value;

  @override
  void onInit() {
    super.onInit();
    fabController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    MultiTween<String> fabTween = MultiTween<String>()
      ..add(
        'plus',
        Tween<double>(begin: 0, end: (RegularSize.xxl * 1) + 10),
      )
      ..add(
        'edit',
        Tween<double>(begin: 0, end: (RegularSize.xxl * 2) + 20),
      )
      ..add(
        'delete',
        Tween<double>(begin: 0, end: (RegularSize.xxl * 3) + 30),
      );
    fabPosition = fabTween.animate(CurvedAnimation(parent: fabController, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    fabController.dispose();
    super.dispose();
  }

  void toggleFAB() {
    if (isShown) {
      fabController.reverse();
      isShown = false;
    } else {
      fabController.forward();
      isShown = true;
    }
  }
}
