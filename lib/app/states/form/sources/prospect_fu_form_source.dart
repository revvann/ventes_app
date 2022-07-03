import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_fu_typedef.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  SearchableDropdownController<UserDetail> ownerDropdownController = Get.put(SearchableDropdownController<UserDetail>(), tag: 'ownerdropdown');
  SearchableDropdownController<BpCustomer> customerDropdownController = Get.put(SearchableDropdownController<BpCustomer>(), tag: 'customerDropdown');
  KeyableDropdownController<int, DBType> stageDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.stageTag + "prospectfu",
  );
  KeyableDropdownController<int, DBType> statusDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.statusTag + "prospectfu",
  );

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

  final Rx<DBType?> _prosstatus = Rx<DBType?>(null);
  final Rx<DBType?> _prosstage = Rx<DBType?>(null);

  DBType? get prosstatus => _prosstatus.value;
  set prosstatus(DBType? value) => _prosstatus.value = value;
  DBType? get prosstage => _prosstage.value;
  set prosstage(DBType? value) => _prosstage.value = value;

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

  String? get prosstartdateString => prosstartdate == null ? null : Utils.formatDate(prosstartdate!);
  String? get prosenddateString => prosenddate == null ? null : Utils.formatDate(prosenddate!);
  String? get prosexpenddateString => prosexpenddate == null ? null : Utils.formatDate(prosexpenddate!);
  String? get prosname => prosnameTEC.text.isBlank ?? true ? null : prosnameTEC.text;
  String? get prosvalue => prosvalueTEC.text.isBlank ?? true ? null : prosvalueTEC.text.replaceAll(RegExp(r'[,.]'), '.');
  String? get prosdesc => prosdescTEC.text.isBlank ?? true ? null : prosdescTEC.text;
  String? get prosownerString => _prosowner.value?.user?.userfullname;
  String? get proscustomerString => _proscustomer.value?.sbccstmname;

  bool get isValid => formKey.currentState?.validate() ?? false;

  @override
  void init() {
    super.init();
    validator.formSource = this;
  }

  @override
  void ready() {
    super.ready();
    prosnameTEC.clear();
    prosvalueTEC.clear();
    prosdescTEC.clear();
    ownerDropdownController.reset();
    customerDropdownController.reset();
  }

  @override
  void close() {
    super.close();
    prosnameTEC.dispose();
    prosvalueTEC.dispose();
    prosdescTEC.dispose();
    Get.delete<SearchableDropdownController<UserDetail>>(tag: 'ownerdropdown');
    Get.delete<SearchableDropdownController<BpCustomer>>(tag: 'customerDropdown');
  }

  @override
  prepareFormValues() {
    prosnameTEC.text = dataSource.prospect?.prospectname ?? "";
    prosvalueTEC.text = Utils.currencyFormat(dataSource.prospect?.prospectvalue.toString() ?? "");
    prosdescTEC.text = dataSource.prospect?.prospectdescription ?? "";

    if (dataSource.prospect?.prospectstartdate != null) {
      prosstartdate = Utils.dbParseDate(dataSource.prospect!.prospectstartdate!);
    }

    if (dataSource.prospect?.prospectenddate != null) {
      prosenddate = Utils.dbParseDate(dataSource.prospect!.prospectenddate!);
    }

    if (dataSource.prospect?.prospectexpclosedate != null) {
      prosexpenddate = Utils.dbParseDate(dataSource.prospect!.prospectexpclosedate!);
    }

    prosowner = dataSource.prospect?.prospectowneruser;
    proscustomer = dataSource.prospect?.prospectcust;
    prosstatus = dataSource.prospect?.prospectstatus;
    prosstage = dataSource.prospect?.prospectstage;

    ownerDropdownController.selectedKeys = prosowner != null ? [prosowner!] : [];
    customerDropdownController.selectedKeys = proscustomer != null ? [proscustomer!] : [];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'prospectname': prosname,
      'prospectstartdate': prosstartdateString,
      'prospectenddate': prosenddateString,
      'prospectvalue': prosvalue?.replaceAll('.', '').replaceAll(',', '.'),
      'prospectowner': _prosowner.value?.user?.userid,
      'prospectstageid': prosstage?.typeid,
      'prospectstatusid': prosstatus?.typeid,
      'prospectexpclosedate': prosexpenddateString,
      'prospectbpid': proscustomer?.sbcbpid,
      'prospectdescription': prosdesc,
      'prospectcustid': proscustomer?.sbcid,
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.updateHandler.fetcher.run(property.prospectId, data);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: "Form is not valid"));
    }
  }
}
