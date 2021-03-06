import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/product_fc_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormCreateFormSource extends StateFormSource with FormSourceMixin {
  Validator validator = Validator();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameTEC = TextEditingController();
  TextEditingController priceTEC = TextEditingController();
  TextEditingController qtyTEC = TextEditingController();
  TextEditingController discTEC = TextEditingController();
  TextEditingController taxTEC = TextEditingController();

  KeyableDropdownController<int, DBType> taxDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.taxDropdownTag,
  );

  int? productbpid;
  final _prosproducttax = Rx<DBType?>(null);
  DBType? get prosproducttax => _prosproducttax.value;
  set prosproducttax(DBType? value) => _prosproducttax.value = value;

  bool get isValid => formKey.currentState?.validate() ?? false;

  String get prosproductname => nameTEC.text;
  String get prosproductprice => priceTEC.text;
  String get prosproductqty => qtyTEC.text;
  String get prosproductdiscount => discTEC.text;
  String get prosproducttaxstring => taxTEC.text;

  @override
  void ready() {
    super.ready();
    nameTEC.clear();
    priceTEC.clear();
    qtyTEC.clear();
    discTEC.clear();
    taxTEC.clear();
    taxDropdownController.reset();
  }

  @override
  void close() {
    super.close();
    nameTEC.dispose();
    priceTEC.dispose();
    qtyTEC.dispose();
    discTEC.dispose();
    taxTEC.dispose();
    Get.delete<KeyableDropdownController<int, DBType>>(tag: ProspectString.taxDropdownTag);
  }

  @override
  Map<String, dynamic> toJson() {
    String priceString = priceTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String qtyString = qtyTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String taxString = taxTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String discString = discTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');

    double price = double.tryParse(priceString) ?? 0;
    double qty = double.tryParse(qtyString) ?? 0;

    double total = price * qty;

    return {
      'productname': prosproductname,
      'productbpid': productbpid,
      'prosproductprice': priceString,
      'prosproductqty': qtyString,
      'prosproducttax': taxString,
      'prosproductdiscount': discString,
      'prosproductamount': total,
      'prosproducttaxtypeid': prosproducttax?.typeid,
      'prosproductprospectid': property.prospectid,
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.createHandler.fetcher.run(data);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: "Please fill all required fields"));
    }
  }
}
