import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_product_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProductFormUpdatePresenter extends RegularPresenter {
  final ProspectProductService _productService = Get.find<ProspectProductService>();
  final TypeService _typeService = Get.find<TypeService>();

  Future<Response> _getTaxes() async {
    return await _typeService.byCode({"typecd": ProspectString.taxTypeCode});
  }

  Future<Response> _getProduct(int id) async {
    return await _productService.show(id);
  }

  SimpleFetcher<List> get fetchTaxes => SimpleFetcher(responseBuilder: _getTaxes, failedMessage: ProspectString.fetchProductFailed);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchProduct => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getProduct(id);
            if (response.statusCode == 200) {
              handler.success(response.body);
            } else {
              handler.failed(ProspectString.fetchProductFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
  DataFetcher<Function(int, Map<String, dynamic>), String> get update => DataFetcher(builder: (handler) {
        return (id, data) async {
          handler.start();
          try {
            Response response = await _productService.update(id, data);
            if (response.statusCode == 200) {
              handler.success(ProspectString.updateProductSuccess);
            } else {
              handler.failed(ProspectString.updateProductFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
