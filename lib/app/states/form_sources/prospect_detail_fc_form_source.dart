part of 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';

class _FormSource extends RegularFormSource {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _Validator validator = _Validator();

  KeyableDropdownController<int, DBType> categoryDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.categoryDropdownTag,
  );

  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.detailTypeCode,
  );

  TextEditingController prosdtdescTEC = TextEditingController();

  final Rx<DBType?> _prosdtcategory = Rx<DBType?>(null);
  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);
  Prospect? prospect;

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdtcategory => _prosdtcategory.value;
  set prosdtcategory(DBType? value) => _prosdtcategory.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  String? get dateString => date != null ? formatDate(date!) : null;

  @override
  init() {
    super.init();
    date = DateTime.now();
  }

  @override
  void close() {
    super.close();
    prosdtdescTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.categoryDropdownTag,
    );
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeCode,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectdtprospectid': prospect?.prospectid?.toString(),
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdtcatid': prosdtcategory?.typeid.toString(),
      'prospectdttypeid': prosdttype?.typeid.toString(),
    };
  }
}
