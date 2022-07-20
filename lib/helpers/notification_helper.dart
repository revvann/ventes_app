import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/routing/route_pack.dart';

class NotificationHelper {
  AwesomeNotifications get notification => AwesomeNotifications();

  Future init() async {
    bool initResult = await notification.initialize(
      NotificationString.icon,
      [
        NotificationChannel(
          channelKey: NotificationString.channelKey,
          channelName: NotificationString.channelName,
          channelDescription: 'Notification channel for ventes',
          defaultColor: RegularColor.primary,
          playSound: true,
        ),
      ],
    );

    if (initResult) {
      AwesomeNotifications().actionStream.listen((notification) {
        int menu = int.parse(notification.payload!['menu']!);
        String route = notification.payload!['route']!;
        Map<String, String>? arguments = notification.payload?..removeWhere((key, value) => ['menu', 'route'].contains(key));

        Get.find<Rx<RoutePack>>().value = RoutePack(Views.values[menu], route, arguments: arguments);
      });
    }
  }

  Future delete(int id) {
    return notification.cancel(id);
  }

  Future<bool> create({
    required NotificationContent content,
    NotificationSchedule? schedule,
    List<NotificationActionButton>? actionButtons,
  }) {
    return notification.createNotification(content: content, schedule: schedule, actionButtons: actionButtons);
  }

  Future<bool> update({
    required NotificationContent content,
    NotificationSchedule? schedule,
    List<NotificationActionButton>? actionButtons,
  }) async {
    await notification.cancel(content.id!);
    return notification.createNotification(content: content, schedule: schedule, actionButtons: actionButtons);
  }
}
