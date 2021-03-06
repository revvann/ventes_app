import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/api/models/bp_customer_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/app/states/typedefs/prospect_fc_typedef.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormCreateFormSource extends StateFormSource with FormSourceMixin {
  Validator validator = Validator();

  SearchableDropdownController<UserDetail> ownerDropdownController = Get.put(SearchableDropdownController<UserDetail>());
  SearchableDropdownController<BpCustomer> customerDropdownController = Get.put(SearchableDropdownController<BpCustomer>());

  final TextEditingController prosnameTEC = TextEditingController();
  final TextEditingController prosvalueTEC = TextEditingController();
  final TextEditingController prosdescTEC = TextEditingController();

  final prosvaluemask = CurrencyInputFormatter();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<DateTime?> _prosstartdate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosenddate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosexpenddate = Rx<DateTime?>(null);
  final Rx<UserDetail?> _prosowner = Rx<UserDetail?>(null);
  final Rx<BpCustomer?> _proscustomer = Rx<BpCustomer?>(null);

  final Rx<List<Map<String, dynamic>>> _prosproducts = Rx<List<Map<String, dynamic>>>([]);

  int? prosstatus;
  int? prosstage;
  DBType? prospectproducttaxdefault;

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
  String? get prosvalue => prosvalueTEC.text.isBlank ?? true ? null : prosvalueTEC.text.replaceAll(RegExp(r'[,.]'), '');
  String? get prosdesc => prosdescTEC.text.isBlank ?? true ? null : prosdescTEC.text;
  String? get prosownerString => _prosowner.value?.user?.userfullname;
  String? get proscustomerString => _proscustomer.value?.sbccstmname;

  List<Map<String, dynamic>> get prosproducts => _prosproducts.value;
  set prosproducts(List<Map<String, dynamic>> value) => _prosproducts.value = value;
  set addprosproduct(Map<String, dynamic> value) => _prosproducts.update((rxprosproduct) => rxprosproduct?.add(value));
  set removeprosproduct(Map<String, dynamic> value) => _prosproducts.update((rxprosproduct) => rxprosproduct?.remove(value));

  bool get isValid => formKey.currentState?.validate() ?? false;

  @override
  init() async {
    super.init();
    validator.formSource = this;
  }

  @override
  ready() async {
    super.ready();
    for (var element in prosproducts) {
      element['nameTEC'].dispose();
      element['priceTEC'].dispose();
      element['qtyTEC'].dispose();
      element['discTEC'].dispose();
      element['taxTEC'].dispose();
    }
    prosproducts = [];

    prosnameTEC.clear();
    prosvalueTEC.clear();
    prosdescTEC.clear();
    ownerDropdownController.reset();
    customerDropdownController.reset();

    int accountId = Get.find<AuthHelper>().accountActive.val!;
    List<UserDetail> userDetails = await dataSource.fetchUser("");
    prosowner = userDetails.firstWhereOrNull((element) => element.userdtid == accountId);
    ownerDropdownController.selectedKeys = prosowner != null ? [prosowner!] : [];
  }

  @override
  close() {
    super.close();

    prosnameTEC.dispose();
    prosvalueTEC.dispose();
    prosdescTEC.dispose();
    Get.delete<SearchableDropdownController<UserDetail>>();
    Get.delete<SearchableDropdownController<BpCustomer>>();

    for (var element in prosproducts) {
      element['nameTEC'].dispose();
      element['priceTEC'].dispose();
      element['qtyTEC'].dispose();
      element['discTEC'].dispose();
      element['taxTEC'].dispose();
    }
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
      'prospectexpclosedate': prosexpenddateString,
      'prospectbpid': proscustomer?.sbcbpid,
      'prospectdescription': prosdesc,
      'prospectcustid': proscustomer?.sbcid,
      'products': productsToJson(),
    };
  }

  List<Map<String, dynamic>> productsToJson() {
    return prosproducts.map((prosproduct) {
      String priceString = prosproduct['priceTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
      String qtyString = prosproduct['qtyTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
      String taxString = prosproduct['taxTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
      String discount = prosproduct['discTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');

      double price = double.tryParse(priceString) ?? 0;
      double qty = double.tryParse(qtyString) ?? 0;

      double total = price * qty;
      return {
        'productname': prosproduct['nameTEC'].text,
        'productbpid': proscustomer?.sbcbpid,
        'prosproductprice': priceString,
        'prosproductqty': qtyString,
        'prosproducttax': taxString,
        'prosproductdiscount': discount,
        'prosproductamount': total.toString(),
        'prosproducttaxtypeid': prosproduct['taxType'].value.typeid.toString(),
      };
    }).toList();
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.createHandler.fetcher.run(data);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: "Form is not valid"));
    }
  }
}
