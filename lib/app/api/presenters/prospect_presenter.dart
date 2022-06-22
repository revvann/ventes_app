import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ProspectPresenter extends RegularPresenter<FetchDataContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final UserService _userService = Get.find<UserService>();
  final ProspectService _prospectService = Get.find<ProspectService>();

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

  Future<Response> _getProspects([Map<String, dynamic> additionParams = const {}]) async {
    UserDetail? userDetail = await findActiveUser();
    Map<String, dynamic> params = {
      'prospectowner': userDetail?.userdtid?.toString(),
      ...additionParams,
    };
    return await _prospectService.select(params);
  }

  SimpleFetcher<List> get fetchStatuses => SimpleFetcher(
        responseBuilder: _getStatusses,
        failedMessage: ProspectString.fetchDataFailed,
      );

  DataFetcher<Function([Map<String, dynamic>?]), List> get fetchProspects => DataFetcher(
        builder: (handler) {
          return ([additionParams]) async {
            handler.onStart();
            try {
              Response response = await _getProspects(additionParams ?? {});
              if (response.statusCode == 200) {
                handler.onSuccess(response.body);
              } else {
                handler.onFailed(ProspectString.fetchDataFailed);
              }
            } catch (e) {
              handler.onError(e.toString());
            }
            handler.onComplete();
          };
        },
      );

  void fetchProspect(Map<String, dynamic> params) async {
    Map<String, dynamic> data = {};
    try {
      Response prospects = await _getProspects(params);
      if (prospects.statusCode == 200) {
        data['prospects'] = prospects.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }
}
