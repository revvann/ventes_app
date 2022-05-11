import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegularStateController extends GetxController {
  final GlobalKey appBarKey = GlobalKey();
  bool get isFixedBody => true;

  final _minHeight = 0.0.obs;
  double get minHeight => _minHeight.value;
  set minHeight(double value) => _minHeight.value = value;
}
