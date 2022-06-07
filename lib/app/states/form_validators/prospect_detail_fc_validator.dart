import 'package:ventes/app/states/form_sources/prospect_detail_fc_form_source.dart';

class ProspectDetailFormCreateValidator {
  late ProspectDetailFormCreateFormSource _formSource;
  ProspectDetailFormCreateValidator(this._formSource);

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
}
