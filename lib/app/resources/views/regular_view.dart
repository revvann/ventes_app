import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/state/controllers/regular_state_controller.dart';

abstract class RegularView<T extends RegularStateController> extends GetView<T> {
  late T state;
  RegularView({Key? key}) : super(key: key) {
    state = controller;
  }
}
