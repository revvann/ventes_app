import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/contact_person_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ContactPersonFormUpdatePresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late UpdateContract _updateContract;
  set updateContract(UpdateContract value) => _updateContract = value;

  Future<Response> _getContactPerson(int contactpersonid) {
    return _contactPersonService.show(contactpersonid);
  }

  Future<Response> _getTypes() {
    return _typeService.byCode({'typecd': ProspectString.contactTypeCode});
  }

  void fetchData(int id) async {
    Map<String, dynamic> data = {};
    try {
      Response typeResponse = await _getTypes();
      Response contactPersonResponse = await _getContactPerson(id);
      if (typeResponse.statusCode == 200 && contactPersonResponse.statusCode == 200) {
        data['contactperson'] = contactPersonResponse.body;
        data['types'] = typeResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(ProspectString.fetchContactFailed);
      }
    } catch (e) {
      _fetchDataContract.onLoadError(e.toString());
    }
  }

  void updateData(int id, Map<String, dynamic> data) async {
    try {
      Response response = await _contactPersonService.update(id, data);
      if (response.statusCode == 200) {
        _updateContract.onUpdateSuccess(ProspectString.updateContactSuccess);
      } else {
        _updateContract.onUpdateFailed(ProspectString.updateContactFailed);
      }
    } catch (e) {
      _updateContract.onUpdateError(e.toString());
    }
  }
}
