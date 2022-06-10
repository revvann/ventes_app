part of 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';

class _DataSource extends RegularDataSource<ContactPersonFormUpdatePresenter> implements ContactPersonUpdateContract {
  _Listener get _listener => Get.find<_Listener>(tag: ProspectString.contactUpdateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.contactUpdateTag);

  final Rx<ContactPerson?> _contactPerson = Rx<ContactPerson?>(null);
  ContactPerson? get contactPerson => _contactPerson.value;
  set contactPerson(ContactPerson? value) => _contactPerson.value = value;

  final Rx<String?> _customerName = Rx<String?>(null);
  String? get customerName => _customerName.value;
  set customerName(String? value) => _customerName.value = value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _types = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  List<KeyableDropdownItem<int, DBType>> get types => _types.value;
  set types(List<KeyableDropdownItem<int, DBType>> value) => _types.value = value;

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
    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((type) => DBType.fromJson(type)).toList();
      _formSource.contacttype = types.isNotEmpty ? types.first : null;
      this.types = types.map<KeyableDropdownItem<int, DBType>>((type) => KeyableDropdownItem<int, DBType>(key: type.typeid!, value: type)).toList();
    }

    if (data['contactperson'] != null) {
      contactPerson = ContactPerson.fromJson(data['contactperson']);
      customerName = contactPerson?.contactcustomer?.cstmname;
      _formSource.prepareFormValue(contactPerson!);
    }
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateContactTaskCode);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
