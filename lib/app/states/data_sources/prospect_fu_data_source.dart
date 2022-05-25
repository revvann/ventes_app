import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_sources/prospect_fu_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormUpdateDataSource implements FetchDataContract, UpdateContract {
  ProspectFormUpdateListener get _listener => Get.find<ProspectFormUpdateListener>();
  ProspectFormUpdateFormSource get _formSource => Get.find<ProspectFormUpdateFormSource>();

  final ProspectFormUpdatePresenter _presenter = ProspectFormUpdatePresenter();

  final _users = <DropdownItem<int, UserDetail>>[].obs;
  List<DropdownItem<int, UserDetail>> get users => _users.value;
  set users(List<DropdownItem<int, UserDetail>> value) => _users.value = value;

  final _bpcustomers = <DropdownItem<int, BpCustomer>>[].obs;
  List<DropdownItem<int, BpCustomer>> get bpcustomers => _bpcustomers.value;
  set bpcustomers(List<DropdownItem<int, BpCustomer>> value) => _bpcustomers.value = value;

  final Rx<Map<int, String>> _followUpItems = Rx<Map<int, String>>({});
  set followUpItems(Map<int, String> value) => _followUpItems.value = value;
  Map<int, String> get followUpItems => _followUpItems.value;

  Prospect? prospect;

  init() {
    _presenter.fetchDataContract = this;
    _presenter.updateContract = this;
  }

  void fetchData(int prospectid) => _presenter.fetchData(prospectid);
  void updateProspect(int prospectid, Map<String, dynamic> data) => _presenter.updateProspect(prospectid, data);

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
          .map<DropdownItem<int, UserDetail>>((item) => DropdownItem<int, UserDetail>(
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

    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
      _formSource.prepareValue();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
