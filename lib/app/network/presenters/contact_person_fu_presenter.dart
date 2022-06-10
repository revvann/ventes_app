import 'package:get/get.dart';
import 'package:ventes/app/network/contracts/update_contract.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/contact_person_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ContactPersonFormUpdatePresenter extends RegularPresenter<ContactPersonUpdateContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

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
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ProspectString.fetchContactFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
  }

  void updateData(int id, Map<String, dynamic> data) async {
    try {
      Response response = await _contactPersonService.update(id, data);
      if (response.statusCode == 200) {
        contract.onUpdateSuccess(ProspectString.updateContactSuccess);
      } else {
        contract.onUpdateFailed(ProspectString.updateContactFailed);
      }
    } catch (e) {
      contract.onUpdateError(e.toString());
    }
  }
}

abstract class ContactPersonUpdateContract implements UpdateContract, FetchDataContract {}
