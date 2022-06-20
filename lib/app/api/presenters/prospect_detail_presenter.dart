import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/delete_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_detail_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailPresenter extends RegularPresenter<ProspectDetailContract> {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();
  final TypeService _typeService = Get.find<TypeService>();

  Future<Response> _getProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _getStages() {
    return _typeService.byCode({'typecd': ProspectString.stageTypeCode});
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
      Response stageResponse = await _getStages();
      if (prospectResponse.statusCode == 200 && prospectDetailResponse.statusCode == 200 && stageResponse.statusCode == 200) {
        data['prospect'] = prospectResponse.body;
        data['prospectdetails'] = prospectDetailResponse.body;
        data['stages'] = stageResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }

  void deleteData(int detailid) async {
    try {
      Response response = await _prospectDetailService.destroy(detailid);
      if (response.statusCode == 200) {
        contract.onDeleteSuccess(ProspectString.deleteProspectDetailSuccess);
      } else {
        contract.onDeleteFailed(ProspectString.deleteProspectDetailFailed);
      }
    } catch (e) {
      contract.onDeleteError(e.toString());
    }
  }
}

abstract class ProspectDetailContract implements FetchDataContract, DeleteContract {}
