import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_fc_presenter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormCreateDataSource extends StateDataSource<ContactPersonFormCreatePresenter> with DataSourceMixin {
  final String typesID = 'typeshdr';
  final String customerID = 'custhdr';
  final String createID = 'createhdr';

  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> typesHandler;
  late DataHandler<Customer?, Map<String, dynamic>, Function(int)> customerHandler;
  late DataHandler<dynamic, String, Function(Map<String, dynamic>)> createHandler;

  Customer? get customer => customerHandler.value;
  List<KeyableDropdownItem<int, DBType>> get types => typesHandler.value;

  List<KeyableDropdownItem<int, DBType>> _typesSuccess(data) {
    List<DBType> types = data.map<DBType>((type) => DBType.fromJson(type)).toList();
    formSource.contacttype = types.isNotEmpty ? types.first : null;
    return types.map<KeyableDropdownItem<int, DBType>>((type) => KeyableDropdownItem<int, DBType>(key: type.typeid!, value: type)).toList();
  }

  void _createSuccess(message) {
    Get.find<TaskHelper>().successPush(Task(createID, message: message, onFinished: (res) {
      Get.find<ContactPersonStateController>().property.refresh();
      Get.back(id: Views.prospect.index);
    }));
  }

  @override
  void init() {
    super.init();
    typesHandler = createDataHandler(typesID, presenter.fetchTypes, [], _typesSuccess);
    customerHandler = createDataHandler(customerID, presenter.fetchCustomer, null, Customer.fromJson, onComplete: () => formSource.customerid = customer?.cstmid);
    createHandler = DataHandler(
      createID,
      fetcher: presenter.create,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
      onFailed: (message) => showFailed(createID, message),
      onError: (message) => showError(createID, message),
      onSuccess: _createSuccess,
    );
  }

  @override
  ContactPersonFormCreatePresenter presenterBuilder() => ContactPersonFormCreatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onCreateError(String message) {}

  @override
  void onCreateFailed(String message) {}

  @override
  void onCreateSuccess(String message) {}

  @override
  void onCreateComplete() {}

  @override
  onLoadComplete() {}
}
