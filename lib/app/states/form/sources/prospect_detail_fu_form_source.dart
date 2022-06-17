part of 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';

class ProspectDetailFormUpdateFormSource extends UpdateFormSource {
  ProspectDetailFormUpdateDataSource get _dataSource => Get.find<ProspectDetailFormUpdateDataSource>(tag: ProspectString.detailUpdateTag);
  ProspectDetailFormUpdateProperty get _properties => Get.find<ProspectDetailFormUpdateProperty>(tag: ProspectString.detailUpdateTag);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProspectDetailFormUpdateValidator validator = ProspectDetailFormUpdateValidator();

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
  void prepareFormValues() {
    prosdtdescTEC.text = _dataSource.prospectdetail!.prospectdtdesc ?? "";
    date = dbParseDate(_dataSource.prospectdetail!.prospectdtdate!);
    prosdtcategory = _dataSource.prospectdetail!.prospectdtcat;
    categoryDropdownController.selectedKeys = [prosdtcategory!.typeid!];
    prosdttype = _dataSource.prospectdetail!.prospectdttype;
    typeDropdownController.selectedKeys = [prosdttype!.typeid!];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdtcatid': prosdtcategory?.typeid.toString(),
      'prospectdttypeid': prosdttype?.typeid.toString(),
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      _dataSource.updateData(_properties.prospectDetailId, data);
      Get.find<TaskHelper>().loaderPush(_properties.task);
    } else {
      Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: "Form invalid, Make sure all fields are filled"));
    }
  }
}
