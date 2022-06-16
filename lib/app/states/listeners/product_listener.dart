part of 'package:ventes/app/states/controllers/product_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.productTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.productTag);

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
    _dataSource.deleteProduct(productid);
    Get.find<TaskHelper>().loaderPush(ProspectString.productTaskCode);
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

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.productTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.productTaskCode, message, () {
      Get.find<ProductStateController>().refreshStates();
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.productTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.productTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
