import 'package:get/get.dart';
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
  String get tag => ProspectString.detailCreateTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.detailCreateTag);
  late int prospectId;

  refresh() {
    _dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(ProspectString.detailTaskCode);
  }
}
