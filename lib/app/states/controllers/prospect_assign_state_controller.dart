import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/api/presenters/prospect_assign_presenter.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_assign_model.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
// import 'package:ventes/app/api/presenters/prospect_assign_presenter.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/data_sources/prospect_assign_data_source.dart';
part 'package:ventes/app/states/listeners/prospect_assign_listener.dart';
part 'package:ventes/app/states/properties/prospect_assign_property.dart';

class ProspectAssignStateController extends RegularStateController<ProspectAssignProperty, ProspectAssignListener, ProspectAssignDataSource> {
  @override
  String get tag => ProspectString.prospectAssignTag;

  @override
  ProspectAssignProperty propertiesBuilder() => ProspectAssignProperty();

  @override
  ProspectAssignListener listenerBuilder() => ProspectAssignListener();

  @override
  ProspectAssignDataSource dataSourceBuilder() => ProspectAssignDataSource();
}
