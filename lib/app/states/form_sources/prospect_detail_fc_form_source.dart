import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_validators/prospect_detail_fc_validator.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProspectDetailFormCreateFormSource {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ProspectDetailFormCreateValidator validator;

  KeyableDropdownController<int, DBType> categoryDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.categoryDropdownTag,
  );

  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.detailTypeCode,
  );

  TextEditingController prosdtdescTEC = TextEditingController();
  TextEditingController prosdtdateTEC = TextEditingController();

  final Rx<DBType?> _prosdtcategory = Rx<DBType?>(null);
  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);
  int? prospectid;

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdtcategory => _prosdtcategory.value;
  set prosdtcategory(DBType? value) => _prosdtcategory.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  String? get dateString => date != null ? formatDate(date!) : null;

  init() {
    date = DateTime.now();
    validator = ProspectDetailFormCreateValidator(this);
  }

  void dispose() {
    prosdtdescTEC.dispose();
    prosdtdateTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.categoryDropdownTag,
    );
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prospectdtprospectid': prospectid.toString(),
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prosdtcategory': prosdtcategory?.typeid.toString(),
      'prosdttype': prosdttype?.typeid.toString(),
    };
  }
}
