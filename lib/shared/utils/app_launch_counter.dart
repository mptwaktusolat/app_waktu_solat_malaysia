import 'package:get_storage/get_storage.dart';

import '../../constants.dart';

/// A utility class to manage the application launch count.
/// This class uses [GetStorage] to persist the launch count.
class AppLaunchCounter {
  static final GetStorage _box = GetStorage();

  /// Increments the application launch count by one.
  static void incrementAppLaunches() {
    final int currentLaunches = getAppLaunches();
    _box.write(kAppLaunchCount, currentLaunches + 1);
  }

  /// Retrieves the current application launch count.
  /// Returns 0 if the count has not been set before.
  static int getAppLaunches() {
    return _box.read<int>(kAppLaunchCount) ?? 0;
  }
}
