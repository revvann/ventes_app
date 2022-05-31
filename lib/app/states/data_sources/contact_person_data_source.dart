import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/contact_person_presenter.dart';
import 'package:ventes/app/states/listeners/contact_person_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonDataSource implements FetchDataContract {
  ContactPersonListener get _listener => Get.find<ContactPersonListener>();

  final ContactPersonPresenter _presenter = ContactPersonPresenter();

  final Rx<BpCustomer?> _bpcustomer = Rx<BpCustomer?>(null);
  final Rx<List<ContactPerson>> _contactPersons = Rx<List<ContactPerson>>([]);

  BpCustomer? get bpcustomer => _bpcustomer.value;
  set bpcustomer(BpCustomer? value) => _bpcustomer.value = value;

  List<ContactPerson> get contactPersons => _contactPersons.value;
  set contactPersons(List<ContactPerson> value) => _contactPersons.value = value;

  init() {
    _presenter.fetchDataContract = this;
  }

  void fetchData(int customerid) => _presenter.fetchData(customerid);

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

    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }
}
