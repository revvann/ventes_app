import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';

abstract class View<T extends RegularStateController> extends GetView<T> {
  late T state;
  View({Key? key}) : super(key: key) {
    state = controller;
  }
}
