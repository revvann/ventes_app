import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/prospect_product_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProductPresenter {
  final _prospectService = Get.find<ProspectService>();
  final _prospectProductService = Get.find<ProspectProductService>();

  late FetchDataContract _fetchContract;
  set fetchContract(FetchDataContract value) => _fetchContract = value;

  Future<Response> _getProspect(int prospectId) async {
    return await _prospectService.show(prospectId);
  }

  Future<Response> _getProspectProducts(int prospectId, [String search = ""]) async {
    Map<String, dynamic> params = {
      'prosproductprospectid': prospectId.toString(),
      'search': search,
    };
    return await _prospectProductService.select(params);
  }

  void fetchData(int prospectid) async {
    Map<String, dynamic> data = {};

    try {
      Response prospectResponse = await _getProspect(prospectid);
      Response prospectProductResponse = await _getProspectProducts(prospectid);

      if (prospectResponse.statusCode == 200 && prospectProductResponse.statusCode == 200) {
        data['prospect'] = prospectResponse.body;
        data['prospectproducts'] = prospectProductResponse.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed(ProspectString.fetchProductFailed);
      }
    } catch (e) {
      _fetchContract.onLoadError(e.toString());
    }
  }

  void fetchProducts(int prospectid, String search) async {
    Map<String, dynamic> data = {};

    try {
      Response prospectProductResponse = await _getProspectProducts(prospectid, search);

      if (prospectProductResponse.statusCode == 200) {
        data['prospectproducts'] = prospectProductResponse.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed(ProspectString.fetchProductFailed);
      }
    } catch (e) {
      _fetchContract.onLoadError(e.toString());
    }
  }
}
