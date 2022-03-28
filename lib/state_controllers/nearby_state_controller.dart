import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/widgets/regular_time_picker.dart';

class NearbyStateController extends RegularStateController {
  final filterTimeInputController = TextEditingController();

  void changeTime() async {
    TimeOfDay? time = await RegularTimePicker().show();
    if (time != null) {
      final localizations = MaterialLocalizations.of(Get.context!);
      final formattedTimeOfDay = localizations.formatTimeOfDay(time);
      filterTimeInputController.text = formattedTimeOfDay;
    }
  }

  @override
  void onInit() {
    super.onInit();
    filterTimeInputController.text = MaterialLocalizations.of(Get.context!).formatTimeOfDay(TimeOfDay.now());
  }

  @override
  void onClose() {
    filterTimeInputController.dispose();
    super.onClose();
  }
}
