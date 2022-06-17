import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/api/presenters/prospect_detail_presenter.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/product/product.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/update/prospect_detail_fu.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/data_sources/prospect_detail_data_source.dart';
part 'package:ventes/app/states/listeners/prospect_detail_listener.dart';
part 'package:ventes/app/states/properties/prospect_detail_property.dart';

class ProspectDetailStateController extends RegularStateController<ProspectDetailProperty, ProspectDetailListener, ProspectDetailDataSource> {
  @override
  String get tag => ProspectString.detailTag;

  @override
  ProspectDetailProperty propertiesBuilder() => ProspectDetailProperty();

  @override
  ProspectDetailListener listenerBuilder() => ProspectDetailListener();

  @override
  ProspectDetailDataSource dataSourceBuilder() => ProspectDetailDataSource();
}
