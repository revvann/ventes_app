part of 'package:ventes/app/states/controllers/product_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.productTag);

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

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
