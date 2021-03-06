import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectFormCreatePresenter extends RegularPresenter {
  final _userService = Get.find<UserService>();
  final _prospectService = Get.find<ProspectService>();
  final _typeService = Get.find<TypeService>();
  final _bpCustomerService = Get.find<BpCustomerService>();

  Future<UserDetail?> findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  Future<Response> _createProspect(Map<String, dynamic> data) async {
    return await _prospectService.store(data);
  }

  Future<Response> _getUsers([String? search]) async {
    UserDetail? activeUser = await findActiveUser();
    Map<String, dynamic> params = {
      'userdtbpid': activeUser?.userdtbpid.toString(),
      'search': search,
    };
    return await _userService.select(params);
  }

  Future<Response> _getBpCustomers([String? search]) async {
    UserDetail? activeUser = await findActiveUser();
    Map<String, dynamic> params = {
      'sbcbpid': activeUser?.userdtbpid.toString(),
      'search': search,
    };
    return await _bpCustomerService.select(params);
  }

  Future<Response> _getStatus() async {
    return await _typeService.byCode({'typecd': ProspectString.statusTypeCode});
  }

  Future<Response> _getTaxes() async {
    return await _typeService.byCode({'typecd': ProspectString.taxTypeCode});
  }

  Future<Response> _getStage() async {
    return await _typeService.byCode({'typecd': ProspectString.stageTypeCode});
  }

  Future<List<UserDetail>> fetchUsers(String? search) async {
    Response response = await _getUsers(search);
    if (response.statusCode == 200) {
      return response.body.map<UserDetail>((item) => UserDetail.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<BpCustomer>> fetchCustomers(String? search) async {
    Response response = await _getBpCustomers(search);
    if (response.statusCode == 200) {
      return response.body.map<BpCustomer>((item) => BpCustomer.fromJson(item)).toList();
    }
    return [];
  }

  SimpleFetcher<List> get fetchStatuses => SimpleFetcher(responseBuilder: _getStatus, failedMessage: ProspectString.fetchDataFailed);
  SimpleFetcher<List> get fetchStages => SimpleFetcher(responseBuilder: _getStage, failedMessage: ProspectString.fetchDataFailed);
  SimpleFetcher<List> get fetchTaxes => SimpleFetcher(responseBuilder: _getTaxes, failedMessage: ProspectString.fetchDataFailed);
  DataFetcher<Function(Map<String, dynamic>), String> get create => DataFetcher(builder: (handler) {
        return (data) async {
          handler.start();
          try {
            Response response = await _createProspect(data);
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
      });
}
