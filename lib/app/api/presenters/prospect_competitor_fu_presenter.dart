import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/competitor_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectCompetitorFormUpdatePresenter extends RegularPresenter {
  final _prospectService = Get.find<ProspectService>();
  final _competitorService = Get.find<CompetitorService>();

  Future<Response> _getProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _getCompetitor(int id) {
    return _competitorService.show(id);
  }

  Future<Response> _updateCompetitor(int id, FormData data) {
    return _competitorService.postUpdate(
      id,
      data,
      contentType: "multipart/form-data",
    );
  }

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
  DataFetcher<Function(int), Map<String, dynamic>> get fetchCompetitor => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getCompetitor(id);
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

  DataFetcher<Function(int, FormData), String> get update => DataFetcher(builder: (handler) {
        return (id, data) async {
          handler.start();
          try {
            Response response = await _updateCompetitor(id, data);
            if (response.statusCode == 200) {
              handler.success(ProspectString.createCompetitorSuccess);
            } else {
              handler.failed(ProspectString.createCompetitorFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
