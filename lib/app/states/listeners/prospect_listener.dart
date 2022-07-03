import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ProspectListener extends StateListener with ListenerMixin {
  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      formSource.prosstartdate = value;
      if (formSource.prosstartdate != null && formSource.prosenddate != null) {
        if (formSource.prosstartdate!.isAfter(formSource.prosenddate!)) {
          formSource.prosenddate = formSource.prosstartdate;
        }
      }
    }
    onFilterChanged();
  }

  void navigateToProspectUpdateForm(int id) {
    Get.toNamed(
      ProspectFormUpdateView.route,
      id: Views.prospect.index,
      arguments: {
        'prospect': id,
      },
    );
  }

  void onCloseWonClicked(int id) {
    if (dataSource.closeWonStatus != null) {
      Map<String, dynamic> data = {
        "prospectstatusid": dataSource.closeWonStatus?.typeid,
      };
      dataSource.prospectUpdateHandler.fetcher.run(id, data);
    }
  }

  void onCloseLoseClicked(int id) {
    if (dataSource.closeLoseStatus != null) {
      Map<String, dynamic> data = {
        "prospectstatusid": dataSource.closeLoseStatus?.typeid,
      };
      dataSource.prospectUpdateHandler.fetcher.run(id, data);
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      formSource.prosenddate = value;
    }
    onFilterChanged();
  }

  void onStatusSelected(selectedItem) {
    if (selectedItem != null) {
      formSource.prosstatus = (selectedItem as KeyableDropdownItem<int, DBType>).value;
    } else {
      formSource.prosstatus = null;
    }
    onFilterChanged();
  }

  void onAddButtonClicked() {
    Get.toNamed(ProspectFormCreateView.route, id: Views.prospect.index);
  }

  Future onFilterChanged() async {
    Map<String, dynamic> filter = formSource.toJson();
    dataSource.prospectsHandler.fetcher.run(filter);
  }

  void onProspectClicked() {
    Get.toNamed(
      ProspectDashboardView.route,
      id: Views.prospect.index,
      arguments: {
        'prospect': property.selectedProspect?.prospectid,
      },
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
