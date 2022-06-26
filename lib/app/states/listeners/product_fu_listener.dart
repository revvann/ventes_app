import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProductFormUpdateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.updateProductConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onTaxChanged(item) {
    formSource.prosproducttax = item.value;
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
