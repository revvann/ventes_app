import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectActivityFormUpdatePresenter extends RegularPresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final ProspectActivityService _prospectActivityService = Get.find<ProspectActivityService>();
  final GmapsService _gmapService = Get.find<GmapsService>();

  Future<Response> _getTypes() async {
    return await _typeService.byCode({'typecd': ProspectString.detailTypeCode});
  }

  Future<Response> _getLocationDetail(double latitude, double longitude) async {
    return await _gmapService.getDetail(latitude, longitude);
  }

  Future<Response> _getProspectActivity(int id) async {
    return await _prospectActivityService.show(id);
  }

  Future<Response> _updateProspect(int id, Map<String, dynamic> data) async {
    return await _prospectActivityService.update(id, data);
  }

  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes, failedMessage: ProspectString.fetchDataFailed);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchProspectActivity => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getProspectActivity(id);
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
  DataFetcher<Function(double, double), Map<String, dynamic>> get fetchLocation => DataFetcher(builder: (handler) {
        return (latitude, longitude) async {
          handler.start();
          try {
            Response response = await _getLocationDetail(latitude, longitude);
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

  DataFetcher<Function(int, Map<String, dynamic>), String> get update => DataFetcher(builder: (handler) {
        return (id, data) async {
          handler.start();
          try {
            Response response = await _updateProspect(id, data);
            if (response.statusCode == 200) {
              handler.success(ProspectString.updateDataSuccess);
            } else {
              handler.failed(ProspectString.updateDataFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
