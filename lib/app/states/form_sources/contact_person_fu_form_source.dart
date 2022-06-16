part of 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';

class _FormSource extends UpdateFormSource {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.contactUpdateTag);

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
    Get.delete<SearchableDropdownController<Contact>>(tag: ProspectString.localContactCode);
    valueTEC.clear();
  }

  @override
  void prepareFormValues() {
    valueTEC.text = _dataSource.contactPerson?.contactvalueid ?? "";
    contacttype = _dataSource.contactPerson?.contacttype;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contactvalueid': isPhone ? contact?.phones?.first.value : valueTEC.text,
    };
  }
}
