import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductListener {
  ProductProperties get _properties => Get.find<ProductProperties>();

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.productTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
    _properties.isLoading.value = false;
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.productTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
    _properties.isLoading.value = false;
  }
}
