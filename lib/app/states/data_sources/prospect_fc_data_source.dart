import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart' as SearchableDropdown;
import 'package:ventes/app/states/form_sources/prospect_fc_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormCreateDataSource implements FetchDataContract, CreateContract {
  ProspectFormCreateListener get _listener => Get.find<ProspectFormCreateListener>();
  ProspectFormCreateFormSource get _formSource => Get.find<ProspectFormCreateFormSource>();

  final ProspectFormCreatePresenter _presenter = ProspectFormCreatePresenter();

  final _users = <SearchableDropdown.DropdownItem<int, UserDetail>>[].obs;
  List<SearchableDropdown.DropdownItem<int, UserDetail>> get users => _users.value;
  set users(List<SearchableDropdown.DropdownItem<int, UserDetail>> value) => _users.value = value;

  final _bpcustomers = <DropdownItem<int, BpCustomer>>[].obs;
  List<DropdownItem<int, BpCustomer>> get bpcustomers => _bpcustomers.value;
  set bpcustomers(List<DropdownItem<int, BpCustomer>> value) => _bpcustomers.value = value;

  final Rx<Map<int, String>> _followUpItems = Rx<Map<int, String>>({});
  set followUpItems(Map<int, String> value) => _followUpItems.value = value;
  Map<int, String> get followUpItems => _followUpItems.value;

  init() {
    _presenter.fetchDataContract = this;
    _presenter.createContract = this;
  }

  void fetchData() => _presenter.fetchData();
  void createProspect(Map<String, dynamic> data) => _presenter.createProspect(data);

  @override
  onLoadError(String message) => _listener.onDataLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onDataLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['users'] != null) {
      List<UserDetail> userList = data['users'].map<UserDetail>((item) => UserDetail.fromJson(item)).toList();
      _formSource.prosowner = userList.isNotEmpty ? userList.first : null;
      users = userList
          .map<SearchableDropdown.DropdownItem<int, UserDetail>>((item) => SearchableDropdown.DropdownItem<int, UserDetail>(
                value: item,
                key: item.userdtid!,
              ))
          .toList();
    }

    if (data['bpcustomers'] != null) {
      List<BpCustomer> bpCustomerList = data['bpcustomers'].map<BpCustomer>((item) => BpCustomer.fromJson(item)).toList();
      _formSource.proscustomer = bpCustomerList.isNotEmpty ? bpCustomerList.first : null;
      bpcustomers = bpCustomerList
          .map<DropdownItem<int, BpCustomer>>((item) => DropdownItem<int, BpCustomer>(
                value: item,
                key: item.sbcid!,
              ))
          .toList();
    }

    if (data['followup'] != null) {
      List<DBType> followUpList = data['followup'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prostype = followUpList.isEmpty ? null : followUpList.first.typeid!;
      followUpItems = followUpList.asMap().map((index, item) => MapEntry(item.typeid!, item.typename!));
    }

    if (data['status'] != null) {
      List<DBType> statusList = data['status'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosstatus = statusList.isEmpty ? null : statusList.first.typeid!;
    }

    if (data['stage'] != null) {
      List<DBType> stageList = data['stage'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosstage = stageList.isEmpty ? null : stageList.first.typeid!;
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }

  @override
  void onCreateError(String message) => _listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => _listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => _listener.onCreateDataSuccess(message);
}
