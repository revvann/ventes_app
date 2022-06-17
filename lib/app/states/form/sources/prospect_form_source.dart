part of 'package:ventes/app/states/controllers/prospect_state_controller.dart';

class ProspectFormSource extends StateFormSource {
  KeyableDropdownController<int, DBType> statusDropdownController = Get.put(KeyableDropdownController<int, DBType>(), tag: ProspectString.statusDropdownTag);

  final Rx<DateTime?> _prosstartdate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosenddate = Rx<DateTime?>(null);
  final Rx<DBType?> _prosstatus = Rx<DBType?>(null);

  int? prostype;

  DateTime? get prosstartdate => _prosstartdate.value;
  set prosstartdate(DateTime? value) => _prosstartdate.value = value;

  DateTime? get prosenddate => _prosenddate.value;
  set prosenddate(DateTime? value) => _prosenddate.value = value;

  DBType? get prosstatus => _prosstatus.value;
  set prosstatus(DBType? value) => _prosstatus.value = value;

  String? get prosstartdateString => prosstartdate == null ? null : formatDate(prosstartdate!);
  String? get prosenddateString => prosenddate == null ? null : formatDate(prosenddate!);

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

    if (prostype != null) {
      json['prospecttypeid'] = prostype.toString();
    }
    return json;
  }

  @override
  void onSubmit() {}
}
