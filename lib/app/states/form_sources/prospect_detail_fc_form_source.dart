import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
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

  final Rx<DBType?> _prosdtcategory = Rx<DBType?>(null);
  final Rx<DBType?> _prosdttype = Rx<DBType?>(null);
  final Rx<List<Map<String, dynamic>>> _prosproducts = Rx<List<Map<String, dynamic>>>([]);

  final Rx<DateTime?> _date = Rx<DateTime?>(null);
  Prospect? prospect;
  DBType? prospectproducttaxdefault;

  bool get isValid => formKey.currentState?.validate() ?? false;

  DateTime? get date => _date.value;
  set date(DateTime? value) => _date.value = value;

  DBType? get prosdtcategory => _prosdtcategory.value;
  set prosdtcategory(DBType? value) => _prosdtcategory.value = value;

  DBType? get prosdttype => _prosdttype.value;
  set prosdttype(DBType? value) => _prosdttype.value = value;

  List<Map<String, dynamic>> get prosproducts => _prosproducts.value;
  set prosproducts(List<Map<String, dynamic>> value) => _prosproducts.value = value;
  set addprosproduct(Map<String, dynamic> value) => _prosproducts.update((rxprosproduct) => rxprosproduct?.add(value));
  set removeprosproduct(Map<String, dynamic> value) => _prosproducts.update((rxprosproduct) => rxprosproduct?.remove(value));

  String? get dateString => date != null ? formatDate(date!) : null;

  init() {
    date = DateTime.now();
    validator = ProspectDetailFormCreateValidator(this);
  }

  void dispose() {
    prosdtdescTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.categoryDropdownTag,
    );
    Get.delete<KeyableDropdownController<int, DBType>>(
      tag: ProspectString.detailTypeCode,
    );
    for (var element in prosproducts) {
      element['nameTEC'].dispose();
      element['priceTEC'].dispose();
      element['qtyTEC'].dispose();
      element['discTEC'].dispose();
      element['taxTEC'].dispose();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'prospectdtprospectid': prospect?.prospectid?.toString(),
      'prospectdtdesc': prosdtdescTEC.text,
      'prospectdtdate': dbFormatDate(date!),
      'prospectdtcatid': prosdtcategory?.typeid.toString(),
      'prospectdttypeid': prosdttype?.typeid.toString(),
      'products': productsToJson(),
    };
  }

  List<Map<String, dynamic>> productsToJson() {
    return prosproducts.map((prosproduct) {
      String priceString = prosproduct['priceTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
      String qtyString = prosproduct['qtyTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
      String taxString = prosproduct['taxTEC'].text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');

      double price = double.tryParse(priceString) ?? 0;
      double qty = double.tryParse(qtyString) ?? 0;

      double total = price * qty;
      return {
        'productname': prosproduct['nameTEC'].text,
        'productbpid': prospect?.prospectbpid?.toString(),
        'prosproductprospectid': prospect?.prospectid?.toString(),
        'prosproductprice': priceString,
        'prosproductqty': qtyString,
        'prosproducttax': taxString,
        'prosproductdiscount': prosproduct['discTEC'].text,
        'prosproductamount': total.toString(),
        'prosproducttaxtypeid': prosproduct['taxType'].value.typeid.toString(),
      };
    }).toList();
  }
}
