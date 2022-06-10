part of 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';

class _FormSource extends RegularFormSource {
  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.contactTypeCode,
  );

  SearchableDropdownController<Contact> contactDropdownController = Get.put(
    SearchableDropdownController<Contact>(),
    tag: ProspectString.localContactCode,
  );

  TextEditingController valueTEC = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _Validator validator = _Validator();

  bool get isValid => formKey.currentState?.validate() ?? false;
  bool get isPhone => contacttype?.typename == "Phone";

  final Rx<DBType?> _contacttype = Rx<DBType?>(null);
  DBType? get contacttype => _contacttype.value;
  set contacttype(DBType? value) => _contacttype.value = value;

  final Rx<Contact?> _contact = Rx<Contact?>(null);
  Contact? get contact => _contact.value;
  set contact(Contact? value) => _contact.value = value;

  @override
  close() {
    super.close();
    Get.delete<KeyableDropdownController<int, DBType>>(tag: ProspectString.contactTypeCode);
    valueTEC.clear();
  }

  void prepareFormValue(ContactPerson contact) {
    valueTEC.text = contact.contactvalueid ?? "";
    contacttype = contact.contacttype;
    typeDropdownController.selectedKeys = contact.contacttype?.typeid != null ? [contact.contacttype!.typeid!] : [];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contacttypeid': contacttype?.typeid?.toString(),
      'contactvalueid': isPhone ? contact?.phones?.first.value : valueTEC.text,
    };
  }
}
