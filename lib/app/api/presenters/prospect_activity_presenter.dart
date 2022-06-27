import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectActivityPresenter extends RegularPresenter {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final ProspectActivityService _prospectActivityService = Get.find<ProspectActivityService>();
  final TypeService _typeService = Get.find<TypeService>();

  Future<Response> _getProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _getStages() {
    return _typeService.byCode({'typecd': ProspectString.stageTypeCode});
  }

  Future<Response> _getProspectActivity(Map<String, dynamic> data) {
    return _prospectActivityService.select(data);
  }

  SimpleFetcher<List> get fetchStages => SimpleFetcher(
        responseBuilder: _getStages,
        failedMessage: ProspectString.fetchDataFailed,
      );

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
            } catch (err) {
              handler.error(err.toString());
            }
            handler.complete();
          };
        },
      );

  DataFetcher<Function(int), List> get fetchProspectActivities => DataFetcher(
        builder: (handler) {
          return (id) async {
            handler.start();
            try {
              Map<String, dynamic> detailParams = {
                'prospectdtprospectid': id.toString(),
              };
              Response response = await _getProspectActivity(detailParams);
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

  DataFetcher<Function(int), String> get delete => DataFetcher(
        builder: (handler) {
          return (detailid) async {
            handler.start();
            try {
              Response response = await _prospectActivityService.destroy(detailid);
              if (response.statusCode == 200) {
                handler.success(ProspectString.deleteProspectActivitySuccess);
              } else {
                handler.failed(ProspectString.deleteProspectActivityFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
}
