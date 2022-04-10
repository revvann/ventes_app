// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/middlewares/auth_middleware.dart';
import 'package:ventes/routes/regular_get_page.dart';
import 'package:ventes/services/auth_service.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/state_controllers/contact_state_controller.dart';
import 'package:ventes/state_controllers/customer_state_controller.dart';
import 'package:ventes/state_controllers/history_state_controller.dart';
import 'package:ventes/state_controllers/dashboard_state_controller.dart';
import 'package:ventes/state_controllers/nearby_state_controller.dart';
import 'package:ventes/state_controllers/schedule_state_controller.dart';
import 'package:ventes/views/signin/signin_state_controller.dart';
import 'package:ventes/state_controllers/splash_screen_state_controller.dart';
import 'package:ventes/state_controllers/started_page_state_controller.dart';
import 'package:ventes/views/Schedule.dart';
import 'package:ventes/views/contact.dart';
import 'package:ventes/views/customer.dart';
import 'package:ventes/views/history.dart';
import 'package:ventes/views/dashboard.dart';
import 'package:ventes/views/main.dart';
import 'package:ventes/views/nearby.dart';
import 'package:ventes/views/signin/signin.dart';
import 'package:ventes/views/started_page.dart';
import 'package:ventes/views/splash_screen.dart';

class RegularRoute {
  static List<GetPage> get routes => [
        RegularGetPage(
          name: SplashScreenView.route,
          page: () => SplashScreenView(),
          bindings: [
            BindingsBuilder(
              () => {
                Get.lazyPut(() => SplashScreenStateController()),
              },
            )
          ],
          middlewares: [
            AuthMiddleware(),
          ],
        ),
        RegularGetPage(
          name: StartedPageView.route,
          page: () => StartedPageView(),
          bindings: [
            BindingsBuilder(
              () => {
                Get.lazyPut(() => StartedPageStateController()),
              },
            )
          ],
          middlewares: [
            AuthMiddleware(),
          ],
        ),
        RegularGetPage(
          name: SigninView.route,
          page: () => SigninView(),
          bindings: [
            BindingsBuilder(
              () => {
                Get.lazyPut(() => AuthService()),
                Get.lazyPut(() => SigninStateController()),
              },
            )
          ],
          middlewares: [
            AuthMiddleware(),
          ],
        ),
        RegularGetPage(
          name: MainView.route,
          page: () => MainView(),
          bindings: [
            BindingsBuilder(
              () => {
                Get.lazyPut(() => BottomNavigationStateController()),
              },
            )
          ],
        ),
      ];
}
