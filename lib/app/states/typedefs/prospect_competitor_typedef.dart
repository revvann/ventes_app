import 'package:ventes/app/states/controllers/prospect_competitor_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_competitor_listener.dart';
import 'package:ventes/app/states/data/sources/prospect_competitor_data_source.dart';
import 'package:ventes/app/states/properties/prospect_competitor_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectCompetitorStateController;

typedef Property = ProspectCompetitorProperty;
typedef Listener = ProspectCompetitorListener;
typedef DataSource = ProspectCompetitorDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
