// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/routing/middlewares/auth_middleware.dart';
import 'package:ventes/routing/routes/regular_get_page.dart';
import 'package:ventes/network/services/auth_service.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/state_controllers/contact_state_controller.dart';
import 'package:ventes/state_controllers/customer_state_controller.dart';
import 'package:ventes/state_controllers/history_state_controller.dart';
import 'package:ventes/state_controllers/dashboard_state_controller.dart';
import 'package:ventes/state_controllers/nearby_state_controller.dart';
import 'package:ventes/state_controllers/schedule_state_controller.dart';
import 'package:ventes/state_controllers/signin_state_controller.dart';
import 'package:ventes/state_controllers/splash_screen_state_controller.dart';
import 'package:ventes/state_controllers/started_page_state_controller.dart';
import 'package:ventes/app/resources/views/Schedule.dart';
import 'package:ventes/app/resources/views/contact.dart';
import 'package:ventes/app/resources/views/customer.dart';
import 'package:ventes/app/resources/views/history.dart';
import 'package:ventes/app/resources/views/dashboard.dart';
import 'package:ventes/app/resources/views/main.dart';
import 'package:ventes/app/resources/views/nearby.dart';
import 'package:ventes/app/resources/views/signin/signin.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';

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
