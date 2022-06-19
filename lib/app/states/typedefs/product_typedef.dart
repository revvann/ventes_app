import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/listeners/product_listener.dart';
import 'package:ventes/app/states/data_sources/product_data_source.dart';
import 'package:ventes/app/states/properties/product_property.dart';
import 'package:ventes/core/states/state_form_source.dart';

typedef Controller = ProductStateController;

typedef Property = ProductProperty;
typedef Listener = ProductListener;
typedef DataSource = ProductDataSource;
typedef FormSource = StateFormSource?;
