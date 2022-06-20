import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/prospect_assign_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectAssignPresenter extends RegularPresenter<FetchDataContract> {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final ProspectAssignService _prospectAssignService = Get.find<ProspectAssignService>();

  Future<Response> _getProspect(int prospectid) async {
    return _prospectService.show(prospectid);
  }

  Future<Response> _getProspectAssign(int prospectid) async {
    Map<String, dynamic> params = {
      'prospectid': prospectid.toString(),
    };
    return _prospectAssignService.select(params);
  }

  void fetchData(int prospectid) async {
    Map<String, dynamic> data = {};
    try {
      Response prospectResponse = await _getProspect(prospectid);
      Response prospectAssignsResponse = await _getProspectAssign(prospectid);
      if (prospectResponse.statusCode == 200 && prospectAssignsResponse.statusCode == 200) {
        data['prospect'] = prospectResponse.body;
        data['prospectassigns'] = prospectAssignsResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }
}
