import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ContactPersonFormCreatePresenter extends RegularPresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final CustomerService _customerService = Get.find<CustomerService>();
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  Future<Response> _getCustomer(int customerid) {
    return _customerService.show(customerid);
  }

  Future<Response> _getTypes() {
    return _typeService.byCode({'typecd': ProspectString.contactTypeCode});
  }

  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchCustomer => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getCustomer(id);
            if (response.statusCode == 200) {
              handler.success(response.body);
            } else {
              handler.failed(ProspectString.fetchContactFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });

  DataFetcher<Function(Map<String, dynamic>), String> get create => DataFetcher(builder: (handler) {
        return (data) async {
          handler.start();
          try {
            Response response = await _contactPersonService.store(data);
            if (response.statusCode == 200) {
              handler.success(ProspectString.createContactSuccess);
            } else {
              handler.failed(ProspectString.createContactFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
