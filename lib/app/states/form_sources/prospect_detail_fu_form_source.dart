import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_validators/prospect_detail_fu_validator.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProspectDetailFormUpdateFormSource {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ProspectDetailFormUpdateValidator validator;

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

  init() {
    date = DateTime.now();
    validator = ProspectDetailFormUpdateValidator(this);
  }

  void dispose() {
    prosdtdescTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.categoryDropdownTag,
    );
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeCode,
    );
  }

  void prepareValue(ProspectDetail prospectDetail) {
    prosdtdescTEC.text = prospectDetail.prospectdtdesc ?? "";
    date = dbParseDate(prospectDetail.prospectdtdate!);
    prosdtcategory = prospectDetail.prospectdtcat;
    categoryDropdownController.selectedItem = [prosdtcategory!.typeid!];
    prosdttype = prospectDetail.prospectdttype;
    typeDropdownController.selectedItem = [prosdttype!.typeid!];
  }

  Map<String, dynamic> toJson() {
    return {
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdtcatid': prosdtcategory?.typeid.toString(),
      'prospectdttypeid': prosdttype?.typeid.toString(),
    };
  }
}
