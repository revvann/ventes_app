part of 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';

class _FormSource extends UpdateFormSource {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.prospectUpdateTag);

  SearchableDropdownController<UserDetail> ownerDropdownController = Get.put(SearchableDropdownController<UserDetail>());
  SearchableDropdownController<BpCustomer> customerDropdownController = Get.put(SearchableDropdownController<BpCustomer>());

  _Validator validator = _Validator();

  final prosvaluemask = CurrencyInputFormatter();

  final TextEditingController prosnameTEC = TextEditingController();
  final TextEditingController prosvalueTEC = TextEditingController();
  final TextEditingController prosdescTEC = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<DateTime?> _prosstartdate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosenddate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosexpenddate = Rx<DateTime?>(null);
  final Rx<UserDetail?> _prosowner = Rx<UserDetail?>(null);
  final Rx<BpCustomer?> _proscustomer = Rx<BpCustomer?>(null);

  final Rx<int?> _prostype = Rx<int?>(null);
  int? prosstatus;
  int? prosstage;

  DateTime? get prosstartdate => _prosstartdate.value;
  set prosstartdate(DateTime? value) => _prosstartdate.value = value;

  DateTime? get prosenddate => _prosenddate.value;
  set prosenddate(DateTime? value) => _prosenddate.value = value;

  DateTime? get prosexpenddate => _prosexpenddate.value;
  set prosexpenddate(DateTime? value) => _prosexpenddate.value = value;

  UserDetail? get prosowner => _prosowner.value;
  set prosowner(UserDetail? value) => _prosowner.value = value;

  BpCustomer? get proscustomer => _proscustomer.value;
  set proscustomer(BpCustomer? value) => _proscustomer.value = value;

  int? get prostype => _prostype.value;
  set prostype(int? value) => _prostype.value = value;

  String? get prosstartdateString => prosstartdate == null ? null : formatDate(prosstartdate!);
  String? get prosenddateString => prosenddate == null ? null : formatDate(prosenddate!);
  String? get prosexpenddateString => prosexpenddate == null ? null : formatDate(prosexpenddate!);
  String? get prosname => prosnameTEC.text.isBlank ?? true ? null : prosnameTEC.text;
  String? get prosvalue => prosvalueTEC.text.isBlank ?? true ? null : prosvalueTEC.text.replaceAll(RegExp(r'[,.]'), '.');
  String? get prosdesc => prosdescTEC.text.isBlank ?? true ? null : prosdescTEC.text;
  String? get prosownerString => _prosowner.value?.user?.userfullname;
  String? get proscustomerString => _proscustomer.value?.sbccstmname;

  bool get isValid => formKey.currentState?.validate() ?? false;

  @override
  void close() {
    super.close();
    prosnameTEC.dispose();
    prosvalueTEC.dispose();
    prosdescTEC.dispose();
    Get.delete<SearchableDropdownController<UserDetail>>();
    Get.delete<SearchableDropdownController<BpCustomer>>();
  }

  @override
  prepareFormValues() {
    prosnameTEC.text = _dataSource.prospect?.prospectname ?? "";
    prosvalueTEC.text = currencyFormat(_dataSource.prospect?.prospectvalue.toString() ?? "");
    prosdescTEC.text = _dataSource.prospect?.prospectdescription ?? "";

    if (_dataSource.prospect?.prospectstartdate != null) {
      prosstartdate = dbParseDate(_dataSource.prospect!.prospectstartdate!);
    }

    if (_dataSource.prospect?.prospectenddate != null) {
      prosenddate = dbParseDate(_dataSource.prospect!.prospectenddate!);
    }

    if (_dataSource.prospect?.prospectexpclosedate != null) {
      prosexpenddate = dbParseDate(_dataSource.prospect!.prospectexpclosedate!);
    }

    prosowner = _dataSource.prospect?.prospectowneruser;
    proscustomer = _dataSource.prospect?.prospectcust;
    prostype = _dataSource.prospect?.prospecttypeid;
    prosstatus = _dataSource.prospect?.prospectstatusid;
    prosstage = _dataSource.prospect?.prospectstageid;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectname': prosname,
      'prospectstartdate': prosstartdateString,
      'prospectenddate': prosenddateString,
      'prospectvalue': prosvalue,
      'prospectowner': _prosowner.value?.user?.userid,
      'prospectstageid': prosstage,
      'prospectstatusid': prosstatus,
      'prospecttypeid': prostype,
      'prospectexpclosedate': prosexpenddateString,
      'prospectbpid': proscustomer?.sbcbpid,
      'prospectdescription': prosdesc,
      'prospectcustid': proscustomer?.sbcid,
    };
  }
}
