import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';

class ContactPersonDataSource extends StateDataSource<ContactPersonPresenter> implements ContactPersonContract {
  Listener get _listener => Get.find<Listener>(tag: ProspectString.contactTag);
  Property get _property => Get.find<Property>(tag: ProspectString.contactTag);

  final Rx<BpCustomer?> _bpcustomer = Rx<BpCustomer?>(null);
  final Rx<List<ContactPerson>> _contactPersons = Rx<List<ContactPerson>>([]);

  BpCustomer? get bpcustomer => _bpcustomer.value;
  set bpcustomer(BpCustomer? value) => _bpcustomer.value = value;

  List<ContactPerson> get contactPersons => _contactPersons.value;
  set contactPersons(List<ContactPerson> value) => _contactPersons.value = value;

  void fetchData(int customerid) => presenter.fetchData(customerid);
  void deleteData(int contactid) => presenter.deleteData(contactid);

  @override
  ContactPersonPresenter presenterBuilder() => ContactPersonPresenter();

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['bpcustomer'] != null && data['bpcustomer'].isNotEmpty) {
      bpcustomer = BpCustomer.fromJson(data['bpcustomer'].first);
    }

    if (data['contacts'] != null) {
      contactPersons = data['contacts'].map<ContactPerson>((e) => ContactPerson.fromJson(e)).toList();
    }

    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  void onDeleteError(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteSuccess(String message) => _listener.onDeleteSuccess(message);
}
