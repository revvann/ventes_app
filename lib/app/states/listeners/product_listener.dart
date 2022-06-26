import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/resources/views/product_form/update/product_fu.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void navigateToFormEdit(int id) {
    Get.toNamed(
      ProductFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        "product": id,
      },
    );
  }

  void deleteProduct(int productid) {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.deleteProductConfirm,
        onFinished: (res) {
          if (res) {
            dataSource.deleteHandler.fetcher.run(productid);
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
