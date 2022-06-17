import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/update_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ContactPersonFormUpdatePresenter extends RegularPresenter<ContactPersonUpdateContract> {
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  Future<Response> _getContactPerson(int contactpersonid) {
    return _contactPersonService.show(contactpersonid);
  }

  void fetchData(int id) async {
    Map<String, dynamic> data = {};
    try {
      Response contactPersonResponse = await _getContactPerson(id);
      if (contactPersonResponse.statusCode == 200) {
        data['contactperson'] = contactPersonResponse.body;
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
