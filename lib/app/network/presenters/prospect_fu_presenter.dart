import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectFormUpdatePresenter {
  final _userService = Get.find<UserService>();
  final _prospectService = Get.find<ProspectService>();
  final _typeService = Get.find<TypeService>();
  final _bpCustomerService = Get.find<BpCustomerService>();

  late final FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;

  late final UpdateContract _updateContract;
  set updateContract(UpdateContract contract) => _updateContract = contract;

  Future<UserDetail?> findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  Future<Response> _updateProspect(int id, Map<String, dynamic> data) async {
    return await _prospectService.update(id, data);
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

  Future<Response> _getFollowUp() async {
    return await _typeService.byCode({'typecd': ProspectString.followUpTypeCode});
  }

  Future<Response> _getStatus() async {
    return await _typeService.byCode({'typecd': ProspectString.statusTypeCode});
  }

  Future<Response> _getStage() async {
    return await _typeService.byCode({'typecd': ProspectString.stageTypeCode});
  }

  Future<Response> _getProspect(int id) async {
    return await _prospectService.show(id);
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

  void fetchData(int prospectid) async {
    Map data = {};
    try {
      Response response = await _getUsers();
      Response bpResponse = await _getBpCustomers();
      Response followUpResponse = await _getFollowUp();
      Response statusResponse = await _getStatus();
      Response stageResponse = await _getStage();
      Response prospectResponse = await _getProspect(prospectid);

      if (response.statusCode == 200 &&
          bpResponse.statusCode == 200 &&
          followUpResponse.statusCode == 200 &&
          statusResponse.statusCode == 200 &&
          stageResponse.statusCode == 200 &&
          prospectResponse.statusCode == 200) {
        data['users'] = response.body;
        data['bpcustomers'] = bpResponse.body;
        data['followup'] = followUpResponse.body;
        data['status'] = statusResponse.body;
        data['stage'] = stageResponse.body;
        data['prospect'] = prospectResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchUsersDataFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  void updateProspect(int prospectid, Map<String, dynamic> data) async {
    try {
      Response response = await _updateProspect(prospectid, data);
      if (response.statusCode == 200) {
        _updateContract.onUpdateSuccess(ProspectString.updateDataSuccess);
      } else {
        _updateContract.onUpdateFailed(ProspectString.updateDataFailed);
      }
    } catch (err) {
      _updateContract.onUpdateError(err.toString());
    }
  }
}
