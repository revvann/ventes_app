import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_assign_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectAssignPresenter extends RegularPresenter {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final ProspectAssignService _prospectAssignService = Get.find<ProspectAssignService>();

  Future<Response> _getProspect(int prospectid) async {
    return _prospectService.show(prospectid);
  }

  Future<Response> _getProspectAssign(int prospectid) async {
    Map<String, dynamic> params = {
      'prospectid': prospectid.toString(),
    };
    return _prospectAssignService.select(params);
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

  DataFetcher<Function(int), List> get fetchProspectAssign => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getProspectAssign(id);
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
}
