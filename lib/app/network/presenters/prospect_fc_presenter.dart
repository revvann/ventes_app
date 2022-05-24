import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectFormCreatePresenter {
  final _userService = Get.find<UserService>();
  final _prospectService = Get.find<ProspectService>();
  final _typeService = Get.find<TypeService>();
  final _bpCustomerService = Get.find<BpCustomerService>();

  late final FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;

  late final CreateContract _createContract;
  set createContract(CreateContract contract) => _createContract = contract;

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

  Future<Response> _getUsers() async {
    UserDetail? activeUser = await findActiveUser();
    Map<String, dynamic> params = {
      'userdtbpid': activeUser?.userdtbpid.toString(),
    };
    return await _userService.select(params);
  }

  Future<Response> _getBpCustomers() async {
    UserDetail? activeUser = await findActiveUser();
    Map<String, dynamic> params = {
      'sbcbpid': activeUser?.userdtbpid.toString(),
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

  void fetchData() async {
    Map data = {};
    try {
      Response response = await _getUsers();
      Response bpResponse = await _getBpCustomers();
      Response followUpResponse = await _getFollowUp();
      Response statusResponse = await _getStatus();
      Response stageResponse = await _getStage();

      if (response.statusCode == 200 && bpResponse.statusCode == 200 && followUpResponse.statusCode == 200 && statusResponse.statusCode == 200 && stageResponse.statusCode == 200) {
        data['users'] = response.body;
        data['bpcustomers'] = bpResponse.body;
        data['followup'] = followUpResponse.body;
        data['status'] = statusResponse.body;
        data['stage'] = stageResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchUsersDataFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  void createProspect(Map<String, dynamic> data) async {
    try {
      Response response = await _createProspect(data);
      if (response.statusCode == 200) {
        _createContract.onCreateSuccess(ProspectString.createDataSuccess);
      } else {
        _createContract.onCreateFailed(ProspectString.createDataFailed);
      }
    } catch (err) {
      _createContract.onCreateError(err.toString());
    }
  }
}
