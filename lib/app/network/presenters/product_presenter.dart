import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/delete_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/prospect_product_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProductPresenter extends RegularPresenter<ProductContract> {
  final _prospectService = Get.find<ProspectService>();
  final _prospectProductService = Get.find<ProspectProductService>();

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
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchProductFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
  }

  void fetchProducts(int prospectid, String search) async {
    Map<String, dynamic> data = {};

    try {
      Response prospectProductResponse = await _getProspectProducts(prospectid, search);

      if (prospectProductResponse.statusCode == 200) {
        data['prospectproducts'] = prospectProductResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchProductFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
  }

  void deleteProduct(int productid) async {
    try {
      Response response = await _prospectProductService.destroy(productid);
      if (response.statusCode == 200) {
        contract.onDeleteSuccess(ProspectString.deleteProductSuccess);
      } else {
        contract.onDeleteFailed(ProspectString.deleteProductFailed);
      }
    } catch (e) {
      contract.onDeleteError(e.toString());
    }
  }
}

abstract class ProductContract implements FetchDataContract, DeleteContract {}
