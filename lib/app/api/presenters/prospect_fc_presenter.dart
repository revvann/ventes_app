import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/contracts/create_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectFormCreatePresenter extends RegularPresenter<ProspectCreateContract> {
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

  void fetchData() async {
    Map data = {};
    try {
      Response statusResponse = await _getStatus();
      Response stageResponse = await _getStage();
      Response taxesResponse = await _getTaxes();

      if (statusResponse.statusCode == 200 && stageResponse.statusCode == 200 && taxesResponse.statusCode == 200) {
        data['status'] = statusResponse.body;
        data['stage'] = stageResponse.body;
        data['taxes'] = taxesResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchUsersDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }

  void createProspect(Map<String, dynamic> data) async {
    try {
      Response response = await _createProspect(data);
      if (response.statusCode == 200) {
        contract.onCreateSuccess(ProspectString.createDataSuccess);
      } else {
        contract.onCreateFailed(ProspectString.createDataFailed);
      }
    } catch (e) {
      contract.onCreateError(e.toString());
    }
    contract.onCreateComplete();
  }
}

abstract class ProspectCreateContract implements FetchDataContract, CreateContract {}
