part of 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';

class _DataSource extends RegularDataSource<ContactPersonFormCreatePresenter> implements ContactPersonCreateContract {
  _Listener get _listener => Get.find<_Listener>(tag: ProspectString.contactCreateTag);
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.contactCreateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.contactCreateTag);

  final Rx<Customer?> _customer = Rx<Customer?>(null);
  Customer? get customer => _customer.value;
  set customer(Customer? value) => _customer.value = value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _types = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  List<KeyableDropdownItem<int, DBType>> get types => _types.value;
  set types(List<KeyableDropdownItem<int, DBType>> value) => _types.value = value;

  void fetchData(int id) => presenter.fetchData(id);
  void createData(Map<String, dynamic> data) => presenter.createData(data);

  @override
  ContactPersonFormCreatePresenter presenterBuilder() => ContactPersonFormCreatePresenter();

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['customer'] != null) {
      customer = Customer.fromJson(data['customer']);
      _formSource.customerid = customer?.cstmid;
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((type) => DBType.fromJson(type)).toList();
      _formSource.contacttype = types.isNotEmpty ? types.first : null;
      this.types = types.map<KeyableDropdownItem<int, DBType>>((type) => KeyableDropdownItem<int, DBType>(key: type.typeid!, value: type)).toList();
    }
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  void onCreateError(String message) => _listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => _listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => _listener.onCreateDataSuccess(message);
}
