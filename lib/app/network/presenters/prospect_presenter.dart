import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectPresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectService _prospectService = Get.find<ProspectService>();

  late final FetchDataContract _fetchContract;
  set fetchContract(FetchDataContract value) => _fetchContract = value;

  Future<Response> _getStatusses() async {
    return await _typeService.byCode({'typecd': ProspectString.statusTypeCode});
  }

  Future<Response> _getFollowUp() async {
    return await _typeService.byCode({'typecd': ProspectString.followUpTypeCode});
  }

  Future<Response> _getProspects() async {
    return await _prospectService.select();
  }

  void fetchData() async {
    Map<String, dynamic> data = {};
    try {
      Response statusses = await _getStatusses();
      Response followUp = await _getFollowUp();
      Response prospects = await _getProspects();
      if (statusses.statusCode == 200 && prospects.statusCode == 200 && followUp.statusCode == 200) {
        data['statusses'] = statusses.body;
        data['followup'] = followUp.body;
        data['prospects'] = prospects.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadError(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      _fetchContract.onLoadError(e.toString());
    }
  }
}
