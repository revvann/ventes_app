part of 'package:ventes/app/states/controllers/product_fu_state_controller.dart';

class ProductFormUpdateProperty extends StateProperty {
  ProductFormUpdateDataSource get _dataSource => Get.find<ProductFormUpdateDataSource>(tag: ProspectString.productUpdateTag);
  late int productid;

  Task task = Task(ProspectString.formUpdateProductTaskCode);

  void refresh() {
    _dataSource.fetchData(productid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
