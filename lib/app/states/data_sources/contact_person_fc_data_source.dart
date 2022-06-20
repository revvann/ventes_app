import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_fc_presenter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';

class ContactPersonFormCreateDataSource extends StateDataSource<ContactPersonFormCreatePresenter> with DataSourceMixin implements ContactPersonCreateContract {
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
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['customer'] != null) {
      customer = Customer.fromJson(data['customer']);
      formSource.customerid = customer?.cstmid;
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((type) => DBType.fromJson(type)).toList();
      formSource.contacttype = types.isNotEmpty ? types.first : null;
      this.types = types.map<KeyableDropdownItem<int, DBType>>((type) => KeyableDropdownItem<int, DBType>(key: type.typeid!, value: type)).toList();
    }
  }

  @override
  void onCreateError(String message) => listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => listener.onCreateDataSuccess(message);

  @override
  void onCreateComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
