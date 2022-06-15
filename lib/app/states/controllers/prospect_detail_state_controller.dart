import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_detail_presenter.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/product/product.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/update/prospect_detail_fu.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

part 'package:ventes/app/states/data_sources/prospect_detail_data_source.dart';
part 'package:ventes/app/states/listeners/prospect_detail_listener.dart';

class ProspectDetailStateController extends RegularStateController<_Properties, _Listener, _DataSource> {
  @override
  String get tag => ProspectString.detailTag;

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
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.detailTag);
  late int prospectId;
  Set<String> popupControllers = {};

  refresh() {
    _dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(ProspectString.detailTaskCode);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }
}
