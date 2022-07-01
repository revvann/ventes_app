import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_fc_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityFormCreateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: Views.prospect.index,
    );
  }

  void onDateSelected(DateTime? date) {
    formSource.date = date;
  }

  void onCategorySelected(category) {
    formSource.prosdtcategory = category.value;
  }

  void onTypeSelected(type) {
    formSource.prosdttype = type.value;
  }

  void onFollowUpSelected(dynamic key) {
    formSource.prosdtcategory = key;
  }

  void onMapControllerCreated(GoogleMapController? controller) {
    if (!property.mapsController.isCompleted) {
      property.mapsController.complete(controller);
    }
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.createDetailConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
