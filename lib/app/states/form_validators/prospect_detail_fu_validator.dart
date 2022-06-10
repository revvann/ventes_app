part of 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';

class _Validator {
  _FormSource get _formSource => Get.find<_FormSource>();

  String? prosdtdesc(String? value) {
    if (value == null) {
      return 'Description is required';
    }

    if (value.isEmpty) {
      return 'Description is required';
    }

    return null;
  }

  String? prosdtdate(String? value) {
    if (_formSource.date == null) {
      return 'Date is required';
    }
    return null;
  }

  String? prosproductname(String? value) {
    if (value == null) {
      return 'Product name is required';
    }

    if (value.isEmpty) {
      return 'Product name is required';
    }

    return null;
  }

  String? prosproductprice(String? value) {
    if (value == null) {
      return 'Product price is required';
    }

    if (value.isEmpty) {
      return 'Product price is required';
    }

    if (double.tryParse(value.replaceAll(RegExp(r'[.,]'), '')) == null) {
      return 'Product price is invalid';
    }

    return null;
  }

  String? prosproducttax(String? value) {
    if (value == null) {
      return 'Product price is required';
    }

    if (value.isEmpty) {
      return 'Product price is required';
    }

    if (double.tryParse(value.replaceAll(RegExp(r'[.,]'), '')) == null) {
      return 'Product price is invalid';
    }

    return null;
  }
}
