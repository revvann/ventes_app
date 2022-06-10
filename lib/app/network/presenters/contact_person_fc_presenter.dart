import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/create_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/contact_person_service.dart';
import 'package:ventes/app/network/services/customer_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ContactPersonFormCreatePresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final CustomerService _customerService = Get.find<CustomerService>();
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late CreateContract _createContract;
  set createContract(CreateContract value) => _createContract = value;

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
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchContactFailed);
      }
    } catch (e) {
      _fetchDataContract.onLoadError(e.toString());
    }
  }

  void createData(Map<String, dynamic> data) async {
    try {
      Response response = await _contactPersonService.store(data);
      if (response.statusCode == 200) {
        _createContract.onCreateSuccess(ProspectString.createContactSuccess);
      } else {
        _createContract.onCreateFailed(ProspectString.createContactFailed);
      }
    } catch (e) {
      _createContract.onCreateError(e.toString());
    }
  }
}
