import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_fu_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/prospect_fu_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormUpdateDataSource extends StateDataSource<ProspectFormUpdatePresenter> with DataSourceMixin implements ProspectUpdateContract {
  final Rx<Map<int, String>> _followUpItems = Rx<Map<int, String>>({});
  set followUpItems(Map<int, String> value) => _followUpItems.value = value;
  Map<int, String> get followUpItems => _followUpItems.value;

  Prospect? prospect;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);
  Future<List<UserDetail>> fetchUser(String? search) async => await presenter.fetchUsers(search);
  Future<List<BpCustomer>> fetchCustomer(String? search) async => await presenter.fetchCustomers(search);
  void updateProspect(int prospectid, Map<String, dynamic> data) => presenter.updateProspect(prospectid, data);

  @override
  ProspectFormUpdatePresenter presenterBuilder() => ProspectFormUpdatePresenter();

  @override
  onLoadError(String message) => listener.onDataLoadError(message);

  @override
  onLoadFailed(String message) => listener.onDataLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['followup'] != null) {
      List<DBType> followUpList = data['followup'].map<DBType>((item) => DBType.fromJson(item)).toList();
      formSource.prostype = followUpList.isEmpty ? null : followUpList.first.typeid!;
      followUpItems = followUpList.asMap().map((index, item) => MapEntry(item.typeid!, item.typename!));
    }

    if (data['status'] != null) {
      List<DBType> statusList = data['status'].map<DBType>((item) => DBType.fromJson(item)).toList();
      formSource.prosstatus = statusList.isEmpty ? null : statusList.first.typeid!;
    }

    if (data['stage'] != null) {
      List<DBType> stageList = data['stage'].map<DBType>((item) => DBType.fromJson(item)).toList();
      formSource.prosstage = stageList.isEmpty ? null : stageList.first.typeid!;
    }

    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
      formSource.prepareFormValues();
    }

    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  void onUpdateError(String message) => listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => listener.onUpdateDataSuccess(message);

  @override
  onLoadComplete() => listener.onComplete();

  @override
  void onUpdateComplete() => listener.onComplete();
}
