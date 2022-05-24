import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/listeners/prospect_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormCreateDataSource implements FetchDataContract {
  ProspectFormCreateListener get _listener => Get.find<ProspectFormCreateListener>();

  final ProspectFormCreatePresenter _presenter = ProspectFormCreatePresenter();

  final _users = <DropdownItem<int, UserDetail>>[].obs;
  List<DropdownItem<int, UserDetail>> get users => _users.value;
  set users(List<DropdownItem<int, UserDetail>> value) => _users.value = value;

  final _bpcustomers = <DropdownItem<int, BpCustomer>>[].obs;
  List<DropdownItem<int, BpCustomer>> get bpcustomers => _bpcustomers.value;
  set bpcustomers(List<DropdownItem<int, BpCustomer>> value) => _bpcustomers.value = value;

  init() {
    _presenter.fetchDataContract = this;
  }

  void fetchData() => _presenter.fetchData();

  @override
  onLoadError(String message) => _listener.onDataLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onDataLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['users'] != null) {
      List<UserDetail> userList = data['users'].map<UserDetail>((item) => UserDetail.fromJson(item)).toList();
      users = userList
          .map<DropdownItem<int, UserDetail>>((item) => DropdownItem<int, UserDetail>(
                value: item,
                key: item.userdtid!,
              ))
          .toList();
    }

    if (data['bpcustomers'] != null) {
      List<BpCustomer> bpCustomerList = data['bpcustomers'].map<BpCustomer>((item) => BpCustomer.fromJson(item)).toList();
      bpcustomers = bpCustomerList
          .map<DropdownItem<int, BpCustomer>>((item) => DropdownItem<int, BpCustomer>(
                value: item,
                key: item.sbcid!,
              ))
          .toList();
    }
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }
}
