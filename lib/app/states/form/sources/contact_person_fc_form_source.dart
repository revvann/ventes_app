part of 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';

class ContactPersonFormCreateFormSource extends StateFormSource {
  ContactPersonFormCreateProperty get _properties => Get.find<ContactPersonFormCreateProperty>(tag: ProspectString.contactCreateTag);
  ContactPersonFormCreateDataSource get _dataSource => Get.find<ContactPersonFormCreateDataSource>(tag: ProspectString.contactCreateTag);

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

  ContactPersonFormCreateValidator validator = ContactPersonFormCreateValidator();

  bool get isValid => formKey.currentState?.validate() ?? false;
  bool get isPhone => contacttype?.typename == "Phone";

  final Rx<DBType?> _contacttype = Rx<DBType?>(null);
  DBType? get contacttype => _contacttype.value;
  set contacttype(DBType? value) => _contacttype.value = value;

  final Rx<Contact?> _contact = Rx<Contact?>(null);
  Contact? get contact => _contact.value;
  set contact(Contact? value) => _contact.value = value;

  int? customerid;

  @override
  close() {
    super.close();
    Get.delete<KeyableDropdownController<int, DBType>>(tag: ProspectString.contactTypeCode);
    Get.delete<SearchableDropdownController<Contact>>(tag: ProspectString.localContactCode);
    valueTEC.dispose();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contacttypeid': contacttype?.typeid?.toString(),
      'contactvalueid': isPhone ? contact?.phones?.first.value : valueTEC.text,
      'contactcustomerid': customerid?.toString(),
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      _dataSource.createData(data);
      Get.find<TaskHelper>().loaderPush(_properties.task);
    } else {
      Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: "Form is not valid"));
    }
  }
}
