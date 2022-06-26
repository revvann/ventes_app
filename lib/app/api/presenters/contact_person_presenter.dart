import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ContactPersonPresenter extends RegularPresenter {
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

  DataFetcher<Function(int), List> get fetchBpCustomers => DataFetcher(builder: (handler) {
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

  DataFetcher<Function(int), List> get fetchContacts => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getContactPerson(id);
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

  DataFetcher<Function(int), String> get delete => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _contactPersonService.destroy(id);
            if (response.statusCode == 200) {
              handler.success(ProspectString.deleteContactSuccess);
            } else {
              handler.failed(ProspectString.deleteContactFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
