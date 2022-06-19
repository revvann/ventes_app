import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_fu_presenter.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';

class ContactPersonFormUpdateDataSource extends StateDataSource<ContactPersonFormUpdatePresenter> implements ContactPersonUpdateContract {
  Listener get _listener => Get.find<Listener>(tag: ProspectString.contactUpdateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.contactUpdateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.contactUpdateTag);

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
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['contactperson'] != null) {
      contactPerson = ContactPerson.fromJson(data['contactperson']);
      customerName = contactPerson?.contactcustomer?.cstmname;
      _formSource.prepareFormValues();
    }
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
