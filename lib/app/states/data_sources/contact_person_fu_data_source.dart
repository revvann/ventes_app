import 'package:get/get.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/contact_person_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_sources/contact_person_fu_form_source.dart';
import 'package:ventes/app/states/listeners/contact_person_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormUpdateDataSource implements FetchDataContract, UpdateContract {
  ContactPersonFormUpdateListener get _listener => Get.find<ContactPersonFormUpdateListener>();
  ContactPersonFormUpdateFormSource get _formSource => Get.find<ContactPersonFormUpdateFormSource>();

  final ContactPersonFormUpdatePresenter _presenter = ContactPersonFormUpdatePresenter();

  final Rx<ContactPerson?> _contactPerson = Rx<ContactPerson?>(null);
  ContactPerson? get contactPerson => _contactPerson.value;
  set contactPerson(ContactPerson? value) => _contactPerson.value = value;

  final Rx<String?> _customerName = Rx<String?>(null);
  String? get customerName => _customerName.value;
  set customerName(String? value) => _customerName.value = value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _types = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  List<KeyableDropdownItem<int, DBType>> get types => _types.value;
  set types(List<KeyableDropdownItem<int, DBType>> value) => _types.value = value;

  init() {
    _presenter.fetchDataContract = this;
    _presenter.updateContract = this;
  }

  void fetchData(int id) => _presenter.fetchData(id);
  void updateData(Map<String, dynamic> data) => _presenter.updateData(contactPerson!.contactpersonid!, data);

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
