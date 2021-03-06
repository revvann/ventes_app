import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/competitor_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectCompetitorPresenter extends RegularPresenter {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final CompetitorService _competitorService = Get.find<CompetitorService>();
  final TypeService _typeService = Get.find<TypeService>();

  Future<Response> _getProspect(int prospectid) async {
    return _prospectService.show(prospectid);
  }

  Future<Response> _getRefTypes() {
    return _typeService.byCode({'typecd': ProspectString.comptRefTypeCode});
  }

  Future<Response> _getCompetitors(int refid, int reftypeid) {
    return _competitorService.select({
      'comptrefid': refid.toString(),
      'comptreftypeid': reftypeid.toString(),
    });
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

  DataFetcher<Function(int, int), List> get fetchCompetitors => DataFetcher(builder: (handler) {
        return (refid, reftypeid) async {
          handler.start();
          try {
            Response response = await _getCompetitors(refid, reftypeid);
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
  SimpleFetcher<List> get fetchRefTypes => SimpleFetcher(responseBuilder: _getRefTypes);
}
