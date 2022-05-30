import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_detail_presenter.dart';
import 'package:ventes/app/states/listeners/prospect_detail_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailDataSource implements FetchDataContract {
  ProspectDetailListener get _listener => Get.find<ProspectDetailListener>();

  final ProspectDetailPresenter _presenter = ProspectDetailPresenter();

  final _prospect = Rx<Prospect?>(null);
  Prospect? get prospect => _prospect.value;
  set prospect(Prospect? value) => _prospect.value = value;

  final _prospectDetails = Rx<List<ProspectDetail>>([]);
  List<ProspectDetail> get prospectDetails => _prospectDetails.value;
  set prospectDetails(List<ProspectDetail> value) => _prospectDetails.value = value;

  void fetchData(int prospectid) => _presenter.fetchData(prospectid);

  init() {
    _presenter.fetchDataContract = this;
  }

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
    }

    if (data['prospectdetails'] != null) {
      prospectDetails = data['prospectdetails'].map<ProspectDetail>((json) => ProspectDetail.fromJson(json)).toList();
    }

    Get.find<TaskHelper>().loaderPop(ProspectString.detailTaskCode);
  }
}
