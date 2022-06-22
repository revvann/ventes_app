import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_listener.dart';
import 'package:ventes/app/states/form/sources/prospect_form_source.dart';
import 'package:ventes/app/states/data/sources/prospect_data_source.dart';
import 'package:ventes/app/states/properties/prospect_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectStateController;

typedef Property = ProspectProperty;
typedef Listener = ProspectListener;
typedef DataSource = ProspectDataSource;
typedef FormSource = ProspectFormSource;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
