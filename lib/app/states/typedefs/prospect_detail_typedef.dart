import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_detail_listener.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_data_source.dart';
import 'package:ventes/app/states/properties/prospect_detail_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectDetailStateController;

typedef Property = ProspectDetailProperty;
typedef Listener = ProspectDetailListener;
typedef DataSource = ProspectDetailDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
