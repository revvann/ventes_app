import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/utils/utils.dart';

class ProspectFormSource extends StateFormSource with FormSourceMixin {
  KeyableDropdownController<int, DBType> statusDropdownController = Get.put(KeyableDropdownController<int, DBType>(), tag: ProspectString.statusDropdownTag);
  KeyableDropdownController<int, DBType> reasonDropdownController = Get.put(KeyableDropdownController<int, DBType>(), tag: ProspectString.reasonDropdownTag);

  final Rx<DateTime?> _prosstartdate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosenddate = Rx<DateTime?>(null);
  final Rx<DBType?> _prosstatus = Rx<DBType?>(null);
  final Rx<DBType?> _lostReason = Rx<DBType?>(null);

  TextEditingController searchTEC = TextEditingController();
  TextEditingController lostDescriptionTEC = TextEditingController();

  DateTime? get prosstartdate => _prosstartdate.value;
  set prosstartdate(DateTime? value) => _prosstartdate.value = value;

  DateTime? get prosenddate => _prosenddate.value;
  set prosenddate(DateTime? value) => _prosenddate.value = value;

  DBType? get prosstatus => _prosstatus.value;
  set prosstatus(DBType? value) => _prosstatus.value = value;
  DBType? get lostReason => _lostReason.value;
  set lostReason(DBType? value) => _lostReason.value = value;

  String? get prosstartdateString => prosstartdate == null ? null : Utils.formatDate(prosstartdate!);
  String? get prosenddateString => prosenddate == null ? null : Utils.formatDate(prosenddate!);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (prosstartdate != null) {
      json['prospectstartdate'] = prosstartdateString;
    }

    if (prosenddate != null) {
      json['prospectenddate'] = prosenddateString;
    }

    if (prosstatus != null) {
      json['prospectstatusid'] = prosstatus?.typeid.toString();
    }
    return json;
  }

  @override
  void onSubmit() {}

  @override
  void ready() {
    super.ready();
    statusDropdownController.reset();
    searchTEC.clear();
  }

  @override
  void close() {
    super.close();
    searchTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(tag: ProspectString.statusDropdownTag);
  }
}
