import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/competitor_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectCompetitorFormCreatePresenter extends RegularPresenter {
  final _typeService = Get.find<TypeService>();
  final _prospectService = Get.find<ProspectService>();
  final _competitorService = Get.find<CompetitorService>();

  Future<Response> _getRefTypes() {
    return _typeService.byCode({'typecd': ProspectString.comptRefTypeCode});
  }

  Future<Response> _getProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _storeCompetitor(FormData data) {
    return _competitorService.store(data);
  }

  SimpleFetcher<List> get fetchRefTypes => SimpleFetcher(responseBuilder: _getRefTypes);
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

  DataFetcher<Function(FormData), String> get create => DataFetcher(builder: (handler) {
        return (data) async {
          handler.start();
          try {
            Response response = await _storeCompetitor(data);
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
