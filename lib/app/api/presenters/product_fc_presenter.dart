import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_product_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProductFormCreatePresenter extends RegularPresenter {
  final ProspectProductService _productService = Get.find<ProspectProductService>();
  final ProspectService _prospectService = Get.find<ProspectService>();
  final TypeService _typeService = Get.find<TypeService>();

  Future<Response> _getTaxes() async {
    return await _typeService.byCode({"typecd": ProspectString.taxTypeCode});
  }

  Future<Response> _getProspect(int id) async {
    return _prospectService.show(id);
  }

  SimpleFetcher<List> get fetchTaxes => SimpleFetcher(responseBuilder: _getTaxes, failedMessage: ProspectString.fetchProductFailed);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchProspect => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getProspect(id);
            if (response.statusCode == 200) {
              handler.success(response.body);
            } else {
              handler.failed(ProspectString.fetchDataFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
  DataFetcher<Function(Map<String, dynamic>), String> get create => DataFetcher(builder: (handler) {
        return (data) async {
          handler.start();
          try {
            Response response = await _productService.store(data);
            if (response.statusCode == 200) {
              handler.success(ProspectString.createProductSuccess);
            } else {
              handler.failed(ProspectString.createProductFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
