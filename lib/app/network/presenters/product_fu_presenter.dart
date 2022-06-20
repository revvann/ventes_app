import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/prospect_product_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProductFormUpdatePresenter extends RegularPresenter<ProductUpdateContract> {
  final ProspectProductService _productService = Get.find<ProspectProductService>();
  final TypeService _typeService = Get.find<TypeService>();

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
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadError(ProspectString.fetchProductFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
  }

  void updateProduct(int id, Map<String, dynamic> data) async {
    try {
      Response response = await _productService.update(id, data);
      if (response.statusCode == 200) {
        contract.onUpdateSuccess(ProspectString.updateProductSuccess);
      } else {
        contract.onUpdateFailed(ProspectString.updateProductFailed);
      }
    } catch (e) {
      contract.onUpdateError(e.toString());
    }
  }
}

abstract class ProductUpdateContract implements UpdateContract, FetchDataContract {}
