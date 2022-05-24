import 'package:ventes/app/states/form_sources/prospect_fc_form_source.dart';

class ProspectFormCreateValidator {
  ProspectFormCreateFormSource _formSource;
  ProspectFormCreateValidator(this._formSource);

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
      double.parse(value);
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
}
