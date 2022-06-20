part of 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';

class _Validator {
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.prospectUpdateTag);

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
      double.parse(_formSource.prosvalue!);
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
