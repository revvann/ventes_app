part of 'package:ventes/app/states/controllers/contact_person_state_controller.dart';

class ContactPersonDataSource extends StateDataSource<ContactPersonPresenter> implements ContactPersonContract {
  ContactPersonListener get _listener => Get.find<ContactPersonListener>(tag: ProspectString.contactTag);
  ContactPersonProperty get _properties => Get.find<ContactPersonProperty>(tag: ProspectString.contactTag);

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

    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  void onDeleteError(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => _listener.onDeleteError(message);

  @override
  void onDeleteSuccess(String message) => _listener.onDeleteSuccess(message);
}
