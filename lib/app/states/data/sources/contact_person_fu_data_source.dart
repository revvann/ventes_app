import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_fu_presenter.dart';
import 'package:ventes/app/api/models/contact_person_model.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormUpdateDataSource extends StateDataSource<ContactPersonFormUpdatePresenter> with DataSourceMixin {
  final String contactID = 'conthdr';
  final String updateID = 'updthdr';

  late DataHandler<ContactPerson?, Map<String, dynamic>, Function(int)> contactHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> updateHandler;

  ContactPerson? get contactPerson => contactHandler.value;
  String? get customerName => contactPerson?.contactcustomer?.cstmname;

  void _updateSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: message,
        onFinished: (res) {
          Get.find<ContactPersonStateController>().property.refresh();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    contactHandler = Utils.createDataHandler(contactID, presenter.fetchContactPerson, null, ContactPerson.fromJson, onComplete: () => formSource.prepareFormValues());
    updateHandler = DataHandler(
      updateID,
      fetcher: presenter.update,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(updateID)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(updateID),
      onError: (message) => Utils.showError(updateID, message),
      onFailed: (message) => Utils.showFailed(updateID, message, false),
      onSuccess: _updateSuccess,
    );
  }

  @override
  ContactPersonFormUpdatePresenter presenterBuilder() => ContactPersonFormUpdatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onUpdateError(String message) {}

  @override
  void onUpdateFailed(String message) {}

  @override
  void onUpdateSuccess(String message) {}

  @override
  onLoadComplete() {}

  @override
  void onUpdateComplete() {}
}
