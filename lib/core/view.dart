import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';

abstract class View<T extends RegularStateController> extends StatelessWidget {
  ///
  /// This method is called everytime widget rebuilds.
  ///
  void onBuild(T state) {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      id: Get.find<T>().tag,
      builder: (state) {
        onBuild(state);
        return buildWidget(context, state);
      },
    );
  }

  Widget buildWidget(BuildContext context, T state);
}
