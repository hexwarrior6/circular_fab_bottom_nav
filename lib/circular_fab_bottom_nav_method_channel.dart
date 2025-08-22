import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'circular_fab_bottom_nav_platform_interface.dart';

/// An implementation of [CircularFabBottomNavPlatform] that uses method channels.
class MethodChannelCircularFabBottomNav extends CircularFabBottomNavPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('circular_fab_bottom_nav');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
