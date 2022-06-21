import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

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
    Get.toNamed(ProspectFormCreateView.route, id: ProspectNavigator.id);
  }

  Future onFilterChanged() async {
    Map<String, dynamic> filter = formSource.toJson();
    dataSource.fetchProspect(params: filter);
    Get.find<TaskHelper>().loaderPush(property.task);
  }

  void onProspectClicked() {
    Get.toNamed(
      ProspectDetailView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': property.selectedProspect?.prospectid,
      },
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.refresh();
  }
}
