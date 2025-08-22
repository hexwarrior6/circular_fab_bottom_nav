
import 'circular_fab_bottom_nav_platform_interface.dart';

class CircularFabBottomNav {
  Future<String?> getPlatformVersion() {
    return CircularFabBottomNavPlatform.instance.getPlatformVersion();
  }
}
