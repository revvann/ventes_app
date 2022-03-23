// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/middlewares/auth_middleware.dart';
import 'package:ventes/routes/regular_get_page.dart';
import 'package:ventes/services/auth_service.dart';
import 'package:ventes/state_controllers/main_state_controller.dart';
import 'package:ventes/state_controllers/signin_state_controller.dart';
import 'package:ventes/state_controllers/splash_screen_state_controller.dart';
import 'package:ventes/state_controllers/started_page_state_controller.dart';
import 'package:ventes/views/main.dart';
import 'package:ventes/views/signin.dart';
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
                Get.lazyPut(() => MainStateController()),
              },
            )
          ],
        ),
      ];
}
