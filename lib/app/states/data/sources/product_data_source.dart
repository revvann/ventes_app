import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/product_presenter.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/prospect_product_model.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/typedefs/product_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductDataSource extends StateDataSource<ProductPresenter> with DataSourceMixin {
  final String prospectID = 'prospethdr';
  final String productsID = 'prodshdr';
  final String deleteID = 'delhdr';

  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<List<ProspectProduct>, List, Function(int, [String])> productsHandler;
  late DataHandler<dynamic, String, Function(int)> deleteHandler;

  Prospect? get prospect => prospectHandler.value;
  List<ProspectProduct> get products => productsHandler.value;

  void _deleteSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        deleteID,
        message: message,
        onFinished: (res) {
          Get.find<ProductStateController>().refreshStates();
        },
      ),
    );
  }

  @override
  init() {
    super.init();
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson);
    productsHandler = Utils.createDataHandler(productsID, presenter.fetchProducts, [], (data) => data.map<ProspectProduct>((e) => ProspectProduct.fromJson(e)).toList());
    deleteHandler = DataHandler(
      deleteID,
      fetcher: presenter.delete,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteID)),
      onSuccess: _deleteSuccess,
      onFailed: (message) => Utils.showFailed(deleteID, message, false),
      onError: (message) => Utils.showError(deleteID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(deleteID),
    );
  }

  @override
  ProductPresenter presenterBuilder() => ProductPresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onDeleteError(String message) {}

  @override
  void onDeleteFailed(String message) {}

  @override
  void onDeleteSuccess(String message) {}

  @override
  void onDeleteComplete() {}

  @override
  onLoadComplete() {}
}
