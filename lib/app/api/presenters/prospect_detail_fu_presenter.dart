import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/update_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/prospect_detail_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailFormUpdatePresenter extends RegularPresenter<ProspectDetailUpdateContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();
  final GmapsService _gmapService = Get.find<GmapsService>();

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
  }

  Future<Response> _getLocationDetail(double latitude, double longitude) async {
    return await _gmapService.getDetail(latitude, longitude);
  }

  Future<Response> _getProspectDetail(int id) async {
    return await _prospectDetailService.show(id);
  }

  Future<Response> _updateProspect(int id, Map<String, dynamic> data) async {
    return await _prospectDetailService.update(id, data);
  }

  void fetchData(int id) async {
    Map data = {};
    try {
      Response typeResponse = await _getTypes();
      Response prospectDetailResponse = await _getProspectDetail(id);

      if (typeResponse.statusCode == 200 && prospectDetailResponse.statusCode == 200) {
        data = {
          'types': typeResponse.body,
          'prospectdetail': prospectDetailResponse.body,
        };

        ProspectDetail prospectDetail = ProspectDetail.fromJson(prospectDetailResponse.body);
        if (prospectDetail.prospectdtlatitude != null && prospectDetail.prospectdtlongitude != null) {
          Response gmapResponse = await _getLocationDetail(prospectDetail.prospectdtlatitude!, prospectDetail.prospectdtlongitude!);
          if (gmapResponse.statusCode == 200) {
            data['locationaddress'] = gmapResponse.body;
            contract.onLoadSuccess(data);
          } else {
            contract.onLoadFailed(ProspectString.fetchDataFailed);
          }
        } else {
          contract.onLoadSuccess(data);
        }
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }

  void updateData(int id, Map<String, dynamic> data) async {
    try {
      Response response = await _updateProspect(id, data);
      if (response.statusCode == 200) {
        contract.onUpdateSuccess(ProspectString.updateDataSuccess);
      } else {
        contract.onUpdateFailed(ProspectString.updateDataFailed);
      }
    } catch (e) {
      contract.onUpdateError(e.toString());
    }
    contract.onUpdateComplete();
  }
}

abstract class ProspectDetailUpdateContract implements UpdateContract, FetchDataContract {}
