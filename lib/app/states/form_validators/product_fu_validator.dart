import 'package:ventes/app/states/form_sources/product_fu_form_source.dart';

class ProductFormUpdateValidator {
  ProductFormUpdateFormSource _formSource;
  ProductFormUpdateValidator(this._formSource);

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
