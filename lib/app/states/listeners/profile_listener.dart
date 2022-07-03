import 'package:ventes/app/states/typedefs/profile_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/utils/utils.dart';

class ProfileListener extends StateListener with ListenerMixin {
  @override
  Future onReady() async {
    dataSource.userDetailHandler.fetcher.run();
  }

  void goBack() {
    Utils.backToDashboard();
  }
}
