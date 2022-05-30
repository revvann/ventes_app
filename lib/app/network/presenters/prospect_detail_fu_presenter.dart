import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/prospect_detail_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailFormUpdatePresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late UpdateContract _updateContract;
  set updateContract(UpdateContract value) => _updateContract = value;

  Future<Response> _getCategories() async {
    return await _typeService.byCode({'typecd': ProspectString.categoryTypeCode});
  }

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
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
      Response categoryResponse = await _getCategories();
      Response typeResponse = await _getTypes();
      Response prospectDetailResponse = await _getProspectDetail(id);

      if (categoryResponse.statusCode == 200 && typeResponse.statusCode == 200 && prospectDetailResponse.statusCode == 200) {
        data = {
          'categories': categoryResponse.body,
          'types': typeResponse.body,
          'prospectdetail': prospectDetailResponse.body,
        };
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      _fetchDataContract.onLoadError(e.toString());
    }
  }

  void updateData(int id, Map<String, dynamic> data) async {
    try {
      Response response = await _updateProspect(id, data);
      if (response.statusCode == 200) {
        _updateContract.onUpdateSuccess(ProspectString.updateDataSuccess);
      } else {
        _updateContract.onUpdateFailed(ProspectString.updateDataFailed);
      }
    } catch (e) {
      _updateContract.onUpdateError(e.toString());
    }
  }
}
