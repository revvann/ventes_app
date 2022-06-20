import 'package:ventes/app/states/typedefs/prospect_fc_typedef.dart';

class ProspectFormCreateValidator {
  late FormSource _formSource;
  set formSource(FormSource value) => _formSource = value;

  String? prosname(String? value) {
    if (value == null || value.isEmpty) {
      return "Prospect name can't be empty";
    }
    return null;
  }

  String? prosvalue(String? value) {
    if (value == null) {
      return "Prospect value can't be empty";
    }

    try {
      double.parse(value.replaceAll(RegExp(r'[,.]'), ''));
    } catch (e) {
      return "Prospect value must be a number";
    }

    return null;
  }

  String? prosstartdate(String? value) {
    if (_formSource.prosstartdate == null) {
      return "Start date can't be empty";
    }
    return null;
  }

  String? prosenddate(String? value) {
    if (_formSource.prosenddate == null) {
      return "End date can't be empty";
    }
    return null;
  }

  String? prosexpenddate(String? value) {
    if (_formSource.prosexpenddate == null) {
      return "Expectation date can't be empty";
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
