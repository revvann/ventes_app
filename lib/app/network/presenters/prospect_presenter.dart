import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectPresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final UserService _userService = Get.find<UserService>();
  final ProspectService _prospectService = Get.find<ProspectService>();

  late final FetchDataContract _fetchContract;
  set fetchContract(FetchDataContract value) => _fetchContract = value;

  Future<UserDetail?> findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  Future<Response> _getStatusses() async {
    return await _typeService.byCode({'typecd': ProspectString.statusTypeCode});
  }

  Future<Response> _getFollowUp() async {
    return await _typeService.byCode({'typecd': ProspectString.followUpTypeCode});
  }

  Future<Response> _getProspects([Map<String, dynamic> additionParams = const {}]) async {
    UserDetail? userDetail = await findActiveUser();
    Map<String, dynamic> params = {
      'prospectbpid': userDetail?.userdtbpid.toString(),
      ...additionParams,
    };
    return await _prospectService.select(params);
  }

  void fetchData() async {
    Map<String, dynamic> data = {};
    try {
      Response statusses = await _getStatusses();
      Response followUp = await _getFollowUp();
      Response prospects = await _getProspects();
      if (statusses.statusCode == 200 && prospects.statusCode == 200 && followUp.statusCode == 200) {
        data['statusses'] = statusses.body;
        data['followup'] = followUp.body;
        data['prospects'] = prospects.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      _fetchContract.onLoadError(e.toString());
    }
  }

  void fetchProspect(Map<String, dynamic> params) async {
    Map<String, dynamic> data = {};
    try {
      Response prospects = await _getProspects(params);
      if (prospects.statusCode == 200) {
        data['prospects'] = prospects.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      _fetchContract.onLoadError(e.toString());
    }
  }
}
