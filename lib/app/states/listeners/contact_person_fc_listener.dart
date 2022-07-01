import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormCreateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: Views.prospect.index,
    );
  }

  void onTypeSelected(type) {
    formSource.contacttype = type.value;
  }

  Future<List<Contact>> onContactFilter(String? search) async {
    return await ContactsService.getContacts(
      query: search,
      withThumbnails: false,
      photoHighResolution: false,
    );
  }

  void onContactChanged(contactItem) {
    formSource.contact = contactItem.value;
  }

  bool onContactCompared(selectedItem, item) {
    return selectedItem == item;
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.createContactConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
