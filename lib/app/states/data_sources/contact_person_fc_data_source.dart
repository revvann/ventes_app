import 'package:get/get.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/contact_person_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_sources/contact_person_fc_form_source.dart';
import 'package:ventes/app/states/listeners/contact_person_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormCreateDataSource implements FetchDataContract, CreateContract {
  ContactPersonFormCreateListener get _listener => Get.find<ContactPersonFormCreateListener>();
  ContactPersonFormCreateFormSource get _formSource => Get.find<ContactPersonFormCreateFormSource>();

  final ContactPersonFormCreatePresenter _presenter = ContactPersonFormCreatePresenter();

  final Rx<Customer?> _customer = Rx<Customer?>(null);
  Customer? get customer => _customer.value;
  set customer(Customer? value) => _customer.value = value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _types = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  List<KeyableDropdownItem<int, DBType>> get types => _types.value;
  set types(List<KeyableDropdownItem<int, DBType>> value) => _types.value = value;

  init() {
    _presenter.fetchDataContract = this;
    _presenter.createContract = this;
  }

  void fetchData(int id) => _presenter.fetchData(id);
  void createData(Map<String, dynamic> data) => _presenter.createData(data);

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
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  @override
  void onCreateError(String message) => _listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => _listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => _listener.onCreateDataSuccess(message);
}
