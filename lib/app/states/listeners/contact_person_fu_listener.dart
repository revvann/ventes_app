import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormUpdateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: Views.prospect.index,
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }

  void onTypeSelected(type) {
    formSource.contacttype = type.value;
  }

  Future<List<Contact>> onContactFilter(String? search) async {
    return await ContactsService.getContacts(query: search);
  }

  void onContactChanged(contactItem) {
    formSource.contact = contactItem.value;
  }

  bool onContactCompared(selectedItem, item) {
    Contact selectedContact = selectedItem;
    Contact contact = item;
    return selectedContact.phones?.first.value == contact.phones?.first.value;
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.updateContactConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }
}
