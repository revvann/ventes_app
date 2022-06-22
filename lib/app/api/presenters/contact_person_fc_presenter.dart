import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/create_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ContactPersonFormCreatePresenter extends RegularPresenter<ContactPersonCreateContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final CustomerService _customerService = Get.find<CustomerService>();
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  Future<Response> _getCustomer(int customerid) {
    return _customerService.show(customerid);
  }

  Future<Response> _getTypes() {
    return _typeService.byCode({'typecd': ProspectString.contactTypeCode});
  }

  void fetchData(int id) async {
    Map<String, dynamic> data = {};
    try {
      Response customerResponse = await _getCustomer(id);
      Response typeResponse = await _getTypes();
      if (customerResponse.statusCode == 200) {
        data['customer'] = customerResponse.body;
        data['types'] = typeResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchContactFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
    contract.onLoadComplete();
  }

  void createData(Map<String, dynamic> data) async {
    try {
      Response response = await _contactPersonService.store(data);
      if (response.statusCode == 200) {
        contract.onCreateSuccess(ProspectString.createContactSuccess);
      } else {
        contract.onCreateFailed(ProspectString.createContactFailed);
      }
    } catch (e) {
      contract.onCreateError(e.toString());
    }
    contract.onCreateComplete();
    contract.onCreateComplete();
  }
}

abstract class ContactPersonCreateContract implements CreateContract, FetchDataContract {}