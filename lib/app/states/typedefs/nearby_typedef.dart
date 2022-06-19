import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/app/states/data_sources/nearby_data_source.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/listeners/nearby_listener.dart';
import 'package:ventes/app/states/properties/nearby_property.dart';

typedef Controller = NearbyStateController;

typedef Property = NearbyProperty;
typedef DataSource = NearbyDataSource;
typedef Listener = NearbyListener;
typedef FormSource = StateFormSource?;
