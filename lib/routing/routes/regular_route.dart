// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/resources/views/main.dart';
import 'package:ventes/app/resources/views/signin/signin.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/routing/middlewares/auth_middleware.dart';
import 'package:ventes/routing/routes/regular_get_page.dart';
import 'package:ventes/app/state/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/app/state/controllers/signin_state_controller.dart';
import 'package:ventes/app/state/controllers/splash_screen_state_controller.dart';
import 'package:ventes/app/state/controllers/started_page_state_controller.dart';

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
