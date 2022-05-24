import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectFormCreatePresenter {
  final _userService = Get.find<UserService>();
  final _bpCustomerService = Get.find<BpCustomerService>();

  late final FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract contract) => _fetchDataContract = contract;

  Future<UserDetail?> findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
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

  void fetchData() async {
    Map data = {};
    try {
      Response response = await _getUsers();
      Response bpResponse = await _getBpCustomers();
      if (response.statusCode == 200 && bpResponse.statusCode == 200) {
        data['users'] = response.body;
        data['bpcustomers'] = bpResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchUsersDataFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }
}
