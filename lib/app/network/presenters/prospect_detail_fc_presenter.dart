import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/prospect_detail_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailFormCreatePresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectDetailService _prospectDetailService = Get.find<ProspectDetailService>();
  final ProspectService _prospectService = Get.find<ProspectService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late CreateContract _createContract;
  set createContract(CreateContract value) => _createContract = value;

  Future<Response> _getCategories() async {
    return await _typeService.byCode({'typecd': ProspectString.categoryTypeCode});
  }

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
  }

  Future<Response> _getTaxes() async {
    return await _typeService.byCode({'typecd': ProspectString.taxTypeCode});
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
      Response taxesResponse = await _getTaxes();

      if (categoryResponse.statusCode == 200 && typeResponse.statusCode == 200 && prospectResponse.statusCode == 200 && taxesResponse.statusCode == 200) {
        data = {
          'categories': categoryResponse.body,
          'types': typeResponse.body,
          'prospect': prospectResponse.body,
          'taxes': taxesResponse.body,
        };
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      _fetchDataContract.onLoadError(e.toString());
    }
  }

  void createData(Map<String, dynamic> data) async {
    try {
      Response response = await _storeProspect(data);
      if (response.statusCode == 200) {
        _createContract.onCreateSuccess(ProspectString.createDataSuccess);
      } else {
        _createContract.onCreateFailed(ProspectString.createDataFailed);
      }
    } catch (e) {
      _createContract.onCreateError(e.toString());
    }
  }
}