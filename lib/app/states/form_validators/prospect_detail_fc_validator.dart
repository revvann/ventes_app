part of 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';

class _Validator {
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.detailCreateTag);

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
