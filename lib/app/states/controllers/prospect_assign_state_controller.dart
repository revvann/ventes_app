import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/network/presenters/prospect_assign_presenter.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_assign_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
// import 'package:ventes/app/network/presenters/prospect_assign_presenter.dart';

part 'package:ventes/app/states/data_sources/prospect_assign_data_source.dart';
part 'package:ventes/app/states/listeners/prospect_assign_listener.dart';

class ProspectAssignStateController extends RegularStateController<_Properties, _Listener, _DataSource> {
  @override
  String get tag => ProspectString.prospectAssignTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  void close() {
    super.close();
    for (var element in properties.popupControllers) {
      Get.delete<PopupMenuController>(tag: element);
    }
  }
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.prospectAssignTag);
  Set<String> popupControllers = {};

  late int prospectid;

  Task task = Task(ProspectString.prospectAssignTaskCode);

  void refresh() {
    _dataSource.fetchData(prospectid);
    Get.find<TaskHelper>().loaderPush(task);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }
}
