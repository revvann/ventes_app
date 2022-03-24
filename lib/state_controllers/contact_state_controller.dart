import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactStateController extends GetxController {
  final GlobalKey appBarKey = GlobalKey();

  final _minHeight = 0.0.obs;
  double get minHeight => _minHeight.value;
  set minHeight(double value) => _minHeight.value = value;

  @override
  void onReady() {
    super.onReady();
    _minHeight.value = Get.height - (appBarKey.currentContext?.size?.height ?? 0);
  }
}
