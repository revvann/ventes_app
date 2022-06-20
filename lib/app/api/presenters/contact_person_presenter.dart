import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/contracts/delete_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ContactPersonPresenter extends RegularPresenter<ContactPersonContract> {
  final BpCustomerService _bpCustomerService = Get.find<BpCustomerService>();
  final UserService _userService = Get.find<UserService>();
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  Future<UserDetail?> _findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  Future<Response> _getBpCustomer(int customerid) async {
    int bpid = (await _findActiveUser())!.userdtbpid!;
    Map<String, dynamic> params = {
      'sbcbpid': bpid.toString(),
      'sbccstmid': customerid.toString(),
    };
    return _bpCustomerService.select(params);
  }

  Future<Response> _getContactPerson(int customerid) async {
    Map<String, dynamic> params = {
      'contactcustomerid': customerid.toString(),
    };
    return _contactPersonService.select(params);
  }

  void fetchData(int customerid) async {
    Map<String, dynamic> data = {};
    try {
      Response bpCustomerResponse = await _getBpCustomer(customerid);
      Response contactPersonResponse = await _getContactPerson(customerid);
      if (bpCustomerResponse.statusCode == 200 && contactPersonResponse.statusCode == 200) {
        data['bpcustomer'] = bpCustomerResponse.body;
        data['contacts'] = contactPersonResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchDataFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }

  void deleteData(int contactid) async {
    try {
      Response response = await _contactPersonService.destroy(contactid);
      if (response.statusCode == 200) {
        contract.onDeleteSuccess(ProspectString.deleteContactSuccess);
      } else {
        contract.onDeleteFailed(ProspectString.deleteContactFailed);
      }
    } catch (e) {
      contract.onDeleteError(e.toString());
    }
  }
}

abstract class ContactPersonContract implements FetchDataContract, DeleteContract {}
