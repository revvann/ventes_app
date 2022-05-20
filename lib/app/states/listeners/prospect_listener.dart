import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/form_sources/prospect_form_source.dart';

class ProspectListener {
  ProspectProperties get _properties => Get.find<ProspectProperties>();
  ProspectFormSource get _formSource => Get.find<ProspectFormSource>();

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosstartdate = value;
      if (_formSource.prosstartdate.isAfter(_formSource.prosenddate)) {
        _formSource.prosenddate = _formSource.prosstartdate;
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosenddate = value;
    }
  }
}
