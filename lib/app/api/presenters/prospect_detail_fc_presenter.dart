import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/create_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/prospect_detail_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailFormCreatePresenter extends RegularPresenter<ProspectDetailCreateContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();
  final ProspectService _prospectService = Get.find<ProspectService>();
  final GmapsService _gmapsService = Get.find<GmapsService>();

  Future<Response> _getCategories() async {
    return await _typeService.byCode({'typecd': ProspectString.categoryTypeCode});
  }

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
  }

  Future<Response> _getProspect(int id) async {
    return await _prospectService.show(id);
  }

  Future<Response> _getLocDetail(double latitude, double longitude) async {
    return await _gmapsService.getDetail(latitude, longitude);
  }

  Future<Response> _storeProspect(Map<String, dynamic> data) async {
    return await _prospectDetailService.store(data);
  }

  void fetchData(int id, double latitude, double langitude) async {
    Map data = {};
    try {
      Response categoryResponse = await _getCategories();
      Response typeResponse = await _getTypes();
      Response prospectResponse = await _getProspect(id);
      Response locResponse = await _getLocDetail(latitude, langitude);

      if (categoryResponse.statusCode == 200 && typeResponse.statusCode == 200 && prospectResponse.statusCode == 200 && locResponse.statusCode == 200) {
        data = {
          'categories': categoryResponse.body,
          'types': typeResponse.body,
          'prospect': prospectResponse.body,
          'location': locResponse.body,
        };
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }

  void createData(Map<String, dynamic> data) async {
    try {
      Response response = await _storeProspect(data);
      if (response.statusCode == 200) {
        contract.onCreateSuccess(ProspectString.createDataSuccess);
      } else {
        contract.onCreateFailed(ProspectString.createDataFailed);
      }
    } catch (e) {
      contract.onCreateError(e.toString());
    }
    contract.onCreateComplete();
  }
}

abstract class ProspectDetailCreateContract implements FetchDataContract, CreateContract {}
