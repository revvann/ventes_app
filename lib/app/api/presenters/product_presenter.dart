import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_product_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProductPresenter extends RegularPresenter {
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

  DataFetcher<Function(int), Map<String, dynamic>> get fetchProspect => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getProspect(id);
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

  DataFetcher<Function(int, [String]), List> get fetchProducts => DataFetcher(builder: (handler) {
        return (id, [search = ""]) async {
          handler.start();
          try {
            Response response = await _getProspectProducts(id, search);
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

  DataFetcher<Function(int), String> get delete => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _prospectProductService.destroy(id);
            if (response.statusCode == 200) {
              handler.success(ProspectString.deleteProductSuccess);
            } else {
              handler.failed(ProspectString.deleteProductFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
