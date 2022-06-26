import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/api/fetcher.dart';

class ContactPersonFormUpdatePresenter extends RegularPresenter {
  final ContactPersonService _contactPersonService = Get.find<ContactPersonService>();

  Future<Response> _getContactPerson(int contactpersonid) {
    return _contactPersonService.show(contactpersonid);
  }

  DataFetcher<Function(int), Map<String, dynamic>> get fetchContactPerson => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getContactPerson(id);
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

  DataFetcher<Function(int, Map<String, dynamic>), String> get update => DataFetcher(builder: (handler) {
        return (id, data) async {
          handler.start();
          try {
            Response response = await _contactPersonService.update(id, data);
            if (response.statusCode == 200) {
              handler.success(ProspectString.updateContactSuccess);
            } else {
              handler.failed(ProspectString.updateContactFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
}
