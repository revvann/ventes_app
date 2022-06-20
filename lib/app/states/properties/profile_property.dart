import 'package:ventes/app/states/typedefs/profile_typedef.dart';
import 'package:ventes/constants/strings/profile_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProfileProperty extends StateProperty with PropertyMixin {
  Task task = Task(ProfileString.taskCode);
}
