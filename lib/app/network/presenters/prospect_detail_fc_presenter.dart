import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/prospect_detail_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailFormCreatePresenter extends RegularPresenter<ProspectDetailCreateContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();
  final ProspectService _prospectService = Get.find<ProspectService>();

  Future<Response> _getCategories() async {
    return await _typeService.byCode({'typecd': ProspectString.categoryTypeCode});
  }

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
  }

  Future<Response> _getProspect(int id) async {
    return await _prospectService.show(id);
  }

  Future<Response> _storeProspect(Map<String, dynamic> data) async {
    return await _prospectDetailService.store(data);
  }

  void fetchData(int id) async {
    Map data = {};
    try {
      Response categoryResponse = await _getCategories();
      Response typeResponse = await _getTypes();
      Response prospectResponse = await _getProspect(id);

      if (categoryResponse.statusCode == 200 && typeResponse.statusCode == 200 && prospectResponse.statusCode == 200) {
        data = {
          'categories': categoryResponse.body,
          'types': typeResponse.body,
          'prospect': prospectResponse.body,
        };
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
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
  }
}

abstract class ProspectDetailCreateContract implements FetchDataContract, CreateContract {}
