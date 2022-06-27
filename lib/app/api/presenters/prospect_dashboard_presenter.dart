import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/prospect_assign_service.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/prospect_product_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ProspectDashboardPresenter extends RegularPresenter {
  final ProspectService _prospectService = Get.find<ProspectService>();
  final UserService _userService = Get.find<UserService>();
  final BpCustomerService _bpCustomerService = Get.find<BpCustomerService>();
  final ProspectProductService _prospectProductService = Get.find<ProspectProductService>();
  final ProspectActivityService _prospectActivityService = Get.find<ProspectActivityService>();
  final ProspectAssignService _prospectAssignService = Get.find<ProspectAssignService>();

  Future<Response> _getProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _getUser(int id) {
    return _userService.show(id);
  }

  Future<Response> _getBpCustomer(int id) {
    return _bpCustomerService.show(id);
  }

  Future<Response> _getProspectProduct(Map<String, dynamic> params) {
    return _prospectProductService.select(params);
  }

  Future<Response> _getProspectActivity(Map<String, dynamic> params) {
    return _prospectActivityService.select(params);
  }

  Future<Response> _getProspectAssign(Map<String, dynamic> params) {
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

  DataFetcher<Function(int), Map<String, dynamic>> get fetchUser => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getUser(id);
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

  DataFetcher<Function(int), Map<String, dynamic>> get fetchBpCustomer => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getBpCustomer(id);
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

  DataFetcher<Function(int), List> get fetchProducts => DataFetcher(builder: (handler) {
        return (prospectid) async {
          handler.start();
          try {
            Map<String, dynamic> params = {
              'prosproductprospectid': prospectid.toString(),
            };
            Response response = await _getProspectProduct(params);
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

  DataFetcher<Function(int), List> get fetchDetails => DataFetcher(builder: (handler) {
        return (prospectid) async {
          handler.start();
          try {
            Map<String, dynamic> params = {
              'prospectdtprospectid': prospectid.toString(),
            };
            Response response = await _getProspectActivity(params);
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

  DataFetcher<Function(int), List> get fetchAssignedUsers => DataFetcher(builder: (handler) {
        return (prospectid) async {
          handler.start();
          try {
            Map<String, dynamic> params = {
              'prospectid': prospectid.toString(),
            };
            Response response = await _getProspectAssign(params);
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
