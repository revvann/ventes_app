import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_fu_presenter.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';

class ContactPersonFormUpdateDataSource extends StateDataSource<ContactPersonFormUpdatePresenter> with DataSourceMixin implements ContactPersonUpdateContract {
  final Rx<ContactPerson?> _contactPerson = Rx<ContactPerson?>(null);
  ContactPerson? get contactPerson => _contactPerson.value;
  set contactPerson(ContactPerson? value) => _contactPerson.value = value;

  final Rx<String?> _customerName = Rx<String?>(null);
  String? get customerName => _customerName.value;
  set customerName(String? value) => _customerName.value = value;

  void fetchData(int id) => presenter.fetchData(id);
  void updateData(Map<String, dynamic> data) => presenter.updateData(contactPerson!.contactpersonid!, data);

  @override
  ContactPersonFormUpdatePresenter presenterBuilder() => ContactPersonFormUpdatePresenter();

  @override
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['contactperson'] != null) {
      contactPerson = ContactPerson.fromJson(data['contactperson']);
      customerName = contactPerson?.contactcustomer?.cstmname;
      formSource.prepareFormValues();
    }
    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  void onUpdateError(String message) => listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => listener.onUpdateDataSuccess(message);

  @override
  onLoadComplete() => listener.onComplete();

  @override
  void onUpdateComplete() => listener.onComplete();
}
