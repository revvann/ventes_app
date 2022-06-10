import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/services/prospect_product_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProductFormUpdatePresenter {
  final ProspectProductService _productService = Get.find<ProspectProductService>();
  final TypeService _typeService = Get.find<TypeService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late UpdateContract _updateContract;
  set updateContract(UpdateContract value) => _updateContract = value;

  Future<Response> _getTaxes() async {
    return await _typeService.byCode({"typecd": ProspectString.taxTypeCode});
  }

  Future<Response> _getProduct(int id) async {
    return await _productService.show(id);
  }

  void fetchData(int id) async {
    Map<String, dynamic> data;
    try {
      Response productResponse = await _getProduct(id);
      Response taxResponse = await _getTaxes();

      if (productResponse.statusCode == 200 && taxResponse.statusCode == 200) {
        data = {"product": productResponse.body, "taxes": taxResponse.body};
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadError(ProspectString.fetchProductFailed);
      }
    } catch (e) {
      _fetchDataContract.onLoadError(e.toString());
    }
  }

  void updateProduct(int id, Map<String, dynamic> data) async {
    try {
      Response response = await _productService.update(id, data);
      if (response.statusCode == 200) {
        _updateContract.onUpdateSuccess(ProspectString.updateProductSuccess);
      } else {
        _updateContract.onUpdateFailed(ProspectString.updateProductFailed);
      }
    } catch (e) {
      _updateContract.onUpdateError(e.toString());
    }
  }
}
