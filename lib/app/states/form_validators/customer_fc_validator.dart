import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';

class CustomerFormCreateValidator {
  CustomerFormCreateValidator(this._formSource);
  CustomerFormCreateFormSource _formSource;

  String? cstmname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
  }

  String? cstmphone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone cannot be empty';
    }
  }

  String? cstmpostalcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code cannot be empty';
    }

    if (value.length > 5) {
      return 'Postal code cannot be more than 5 characters';
    }
  }

  String? cstmaddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address cannot be empty';
    }
  }
}
