import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/form_sources/regular_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/prospect_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/states/data_sources/prospect_data_source.dart';
part 'package:ventes/app/states/form_sources/prospect_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_listener.dart';

class ProspectStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ProspectString.prospectTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  _FormSource formSourceBuilder() => _FormSource();
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.prospectTag);

  Prospect? selectedProspect;

  void refresh() {
    _dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(ProspectString.taskCode);
  }
}
