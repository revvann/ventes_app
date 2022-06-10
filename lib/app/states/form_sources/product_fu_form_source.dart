import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/form_validators/product_fu_validator.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProductFormUpdateFormSource {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ProductFormUpdateValidator validator;

  TextEditingController nameTEC = TextEditingController();
  TextEditingController priceTEC = TextEditingController();
  TextEditingController qtyTEC = TextEditingController();
  TextEditingController discTEC = TextEditingController();
  TextEditingController taxTEC = TextEditingController();

  KeyableDropdownController<int, DBType> taxDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.taxDropdownTag,
  );

  final _prosproducttax = Rx<DBType?>(null);
  DBType? get prosproducttax => _prosproducttax.value;
  set prosproducttax(DBType? value) => _prosproducttax.value = value;

  bool get isValid => formKey.currentState?.validate() ?? false;

  String get prosproductname => nameTEC.text;
  String get prosproductprice => priceTEC.text;
  String get prosproductqty => qtyTEC.text;
  String get prosproductdiscount => discTEC.text;
  String get prosproducttaxstring => taxTEC.text;

  init() {
    validator = ProductFormUpdateValidator(this);
  }

  void prepareFormValue(ProspectProduct product) {
    nameTEC.text = product.prosproductproduct?.productname ?? "";
    priceTEC.text = currencyFormat(product.prosproductprice?.toString().replaceAll('.', ',') ?? "");
    qtyTEC.text = product.prosproductqty?.toString().replaceAll('.', ',') ?? "";
    discTEC.text = product.prosproductdiscount?.toString().replaceAll('.', ',') ?? "";
    taxTEC.text = currencyFormat(product.prosproducttax?.toString().replaceAll('.', ',') ?? "");
    prosproducttax = product.prosproducttaxtype;
    taxDropdownController.selectedKeys = prosproducttax != null ? [prosproducttax!.typeid!] : [];
  }

  Map<String, dynamic> toJson() {
    String priceString = priceTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String qtyString = qtyTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String taxString = taxTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');

    double price = double.tryParse(priceString) ?? 0;
    double qty = double.tryParse(qtyString) ?? 0;

    double total = price * qty;

    return {
      'productname': prosproductname,
      'prosproductprice': priceString,
      'prosproductqty': qtyString,
      'prosproducttax': taxString,
      'prosproductdiscount': prosproductdiscount,
      'prosproductamount': total.toString(),
      'prosproducttaxtypeid': prosproducttax?.typeid.toString(),
    };
  }
}
