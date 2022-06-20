import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_detail_presenter.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailDataSource extends StateDataSource<ProspectDetailPresenter> with DataSourceMixin implements ProspectDetailContract {
  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? value) => _prospect.value = value;

  final _prospectDetails = Rx<List<ProspectDetail>>([]);
  List<ProspectDetail> get prospectDetails => _prospectDetails.value;
  set prospectDetails(List<ProspectDetail> value) => _prospectDetails.value = value;

  final _stages = Rx<List<DBType>>([]);
  List<DBType> get stages => _stages.value;
  set stages(List<DBType> value) => _stages.value = value;

  void fetchData(int prospectid) => presenter.fetchData(prospectid);
  void deleteData(int detailid) => presenter.deleteData(detailid);

  @override
  ProspectDetailPresenter presenterBuilder() => ProspectDetailPresenter();

  @override
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectdetails'] != null) {
      prospectDetails = data['prospectdetails'].map<ProspectDetail>((json) => ProspectDetail.fromJson(json)).toList();
    }

    if (data['stages'] != null) {
      stages = data['stages'].map<DBType>((json) => DBType.fromJson(json)).toList();
    }

    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  @override
  void onDeleteError(String message) => listener.onDeleteError(message);

  @override
  void onDeleteFailed(String message) => listener.onDeleteFailed(message);

  @override
  void onDeleteSuccess(String message) => listener.onDeleteSuccess(message);

  @override
  void onDeleteComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
