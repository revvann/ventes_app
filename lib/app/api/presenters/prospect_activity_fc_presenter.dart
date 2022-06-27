import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectActivityFormCreatePresenter extends RegularPresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectActivityService _prospectActivityService = Get.find<ProspectActivityService>();
  final ProspectService _prospectService = Get.find<ProspectService>();
  final GmapsService _gmapsService = Get.find<GmapsService>();

  Future<Response> _getCategories() async {
    return await _typeService.byCode({'typecd': ProspectString.categoryTypeCode});
  }

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
  }

  Future<Response> _getProspect(int id) async {
    return await _prospectService.show(id);
  }

  Future<Response> _getLocDetail(double latitude, double longitude) async {
    return await _gmapsService.getDetail(latitude, longitude);
  }

  Future<Response> _storeProspect(Map<String, dynamic> data) async {
    return await _prospectActivityService.store(data);
  }

  SimpleFetcher<List> get fetchCategories => SimpleFetcher(responseBuilder: _getCategories);
  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchProspect => DataFetcher(
        builder: (handler) {
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
        },
      );
  DataFetcher<Function(double, double), Map<String, dynamic>> get fetchLocation => DataFetcher(
        builder: (handler) {
          return (latitude, longitude) async {
            handler.start();
            try {
              Response response = await _getLocDetail(latitude, longitude);
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
        },
      );
  DataFetcher<Function(Map<String, dynamic>), String> get create => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _storeProspect(data);
              if (response.statusCode == 200) {
                handler.success(ProspectString.createDataSuccess);
              } else {
                handler.failed(ProspectString.createDataFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
}
