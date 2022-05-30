import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/prospect_detail_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailPresenter {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  Future<Response> _getProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _getProspectDetail(Map<String, dynamic> data) {
    return _prospectDetailService.select(data);
  }

  void fetchData(int prospectid) async {
    Map<String, dynamic> data = {};
    Map<String, dynamic> detailParams = {
      'prospectdtprospectid': prospectid.toString(),
    };
    try {
      Response prospectResponse = await _getProspect(prospectid);
      Response prospectDetailResponse = await _getProspectDetail(detailParams);
      if (prospectResponse.statusCode == 200 && prospectDetailResponse.statusCode == 200) {
        data['prospect'] = prospectResponse.body;
        data['prospectdetails'] = prospectDetailResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      _fetchDataContract.onLoadError(e.toString());
    }
  }
}
