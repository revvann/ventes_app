import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/prospect_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/data_sources/prospect_data_source.dart';
part 'package:ventes/app/states/form/sources/prospect_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_listener.dart';
part 'package:ventes/app/states/properties/prospect_property.dart';

class ProspectStateController extends FormStateController<ProspectProperty, ProspectListener, ProspectDataSource, ProspectFormSource> {
  @override
  String get tag => ProspectString.prospectTag;

  @override
  ProspectProperty propertiesBuilder() => ProspectProperty();

  @override
  ProspectListener listenerBuilder() => ProspectListener();

  @override
  ProspectDataSource dataSourceBuilder() => ProspectDataSource();

  @override
  ProspectFormSource formSourceBuilder() => ProspectFormSource();
}
