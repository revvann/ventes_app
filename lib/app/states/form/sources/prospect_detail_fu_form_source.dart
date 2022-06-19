import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form/validators/prospect_detail_fu_validator.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fu_typedef.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormUpdateFormSource extends UpdateFormSource {
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.detailUpdateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.detailUpdateTag);
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
      _dataSource.updateData(_property.prospectDetailId, data);
      Get.find<TaskHelper>().loaderPush(_property.task);
    } else {
      Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: "Form invalid, Make sure all fields are filled"));
    }
  }
}
