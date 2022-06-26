import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';

class ContactPersonDataSource extends StateDataSource<ContactPersonPresenter> with DataSourceMixin {
  final String bpCustomersID = 'bpcustshdr';
  final String contactsID = 'contshdr';
  final String deleteID = 'delhdr';

  late DataHandler<BpCustomer?, List, Function(int)> bpCustomerHandler;
  late DataHandler<List<ContactPerson>, List, Function(int)> contactsHandler;
  late DataHandler<dynamic, String, Function(int)> deleteHandler;

  BpCustomer? get bpcustomer => bpCustomerHandler.value;
  List<ContactPerson> get contactPersons => contactsHandler.value;

  void _deleteSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        deleteID,
        message: message,
        onFinished: (res) async {
          Get.find<ContactPersonStateController>().refreshStates();
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    bpCustomerHandler = createDataHandler(bpCustomersID, presenter.fetchBpCustomers, null, (data) => BpCustomer.fromJson(data.first));
    contactsHandler = createDataHandler(contactsID, presenter.fetchContacts, [], (data) => data.map<ContactPerson>((e) => ContactPerson.fromJson(e)).toList());
    deleteHandler = DataHandler(
      deleteID,
      fetcher: presenter.delete,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteID)),
      onFailed: (message) => showFailed(deleteID, message, false),
      onError: (message) => showError(deleteID, message),
      onSuccess: _deleteSuccess,
      onComplete: () => Get.find<TaskHelper>().loaderPop(deleteID),
    );
  }

  @override
  ContactPersonPresenter presenterBuilder() => ContactPersonPresenter();
}
