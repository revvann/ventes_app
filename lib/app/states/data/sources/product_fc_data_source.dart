// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/presenters/product_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/typedefs/product_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

class ProductFormCreateDataSource extends StateDataSource<ProductFormCreatePresenter> with DataSourceMixin {
  final String taxesID = 'taxhdr';
  final String createID = 'updthdr';
  final String prospectID = 'prospecthdr';

  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> taxesHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> createHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;

  List<KeyableDropdownItem<int, DBType>> get taxItems => taxesHandler.value;
  Prospect? get prospect => prospectHandler.value;

  List<KeyableDropdownItem<int, DBType>> _taxesSuccess(data) {
    List<DBType> taxes = data.map<DBType>((tax) => DBType.fromJson(tax)).toList();
    formSource.prosproducttax = taxes.firstWhereOrNull((element) => true);
    return taxes.map<KeyableDropdownItem<int, DBType>>((tax) => KeyableDropdownItem<int, DBType>(key: tax.typeid!, value: tax)).toList();
  }

  void _createSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: message,
        onFinished: (res) {
          Get.find<ProductStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    taxesHandler = Utils.createDataHandler(taxesID, presenter.fetchTaxes, [], _taxesSuccess);
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson, onComplete: () => formSource.productbpid = prospect?.prospectbpid);
    createHandler = DataHandler(
      createID,
      fetcher: presenter.create,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onSuccess: _createSuccess,
      onFailed: (message) => Utils.showFailed(createID, message, false),
      onError: (message) => Utils.showError(createID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
    );
  }

  @override
  ProductFormCreatePresenter presenterBuilder() => ProductFormCreatePresenter();
}
