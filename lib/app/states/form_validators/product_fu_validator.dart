part of 'package:ventes/app/states/controllers/product_fu_state_controller.dart';

class _Validator {
  String? prosproductname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product name is required';
    }
    return null;
  }

  String? prosproductprice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product price is required';
    }

    try {
      double.parse(value.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.'));
    } catch (e) {
      return 'Product price must be a number';
    }

    return null;
  }

  String? prosproducttax(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product price is required';
    }

    try {
      double.parse(value.replaceAll('.', '').replaceAll(',', '.'));
    } catch (e) {
      return 'Product price must be a number';
    }

    return null;
  }
}
