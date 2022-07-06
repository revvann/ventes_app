import 'package:ventes/app/states/data/sources/prospect_competitor_fc_data_source.dart';
import 'package:ventes/app/states/controllers/prospect_competitor_fc_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_competitor_fc_listener.dart';
import 'package:ventes/app/states/properties/prospect_competitor_fc_property.dart';
import 'package:ventes/app/states/form/sources/prospect_competitor_fc_form_source.dart';
import 'package:ventes/app/states/form/validators/prospect_competitor_fc_validator.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectCompetitorFormCreateStateController;

typedef Property = ProspectCompetitorFormCreateProperty;
typedef Listener = ProspectCompetitorFormCreateListener;
typedef DataSource = ProspectCompetitorFormCreateDataSource;
typedef FormSource = ProspectCompetitorFormCreateFormSource;
typedef Validator = ProspectCompetitorFormCreateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
