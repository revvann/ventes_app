import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/listeners/product_listener.dart';
import 'package:ventes/app/states/data/sources/product_data_source.dart';
import 'package:ventes/app/states/properties/product_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProductStateController;

typedef Property = ProductProperty;
typedef Listener = ProductListener;
typedef DataSource = ProductDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
