import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailFormCreateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
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
