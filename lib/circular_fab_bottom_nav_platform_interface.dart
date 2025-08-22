import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'circular_fab_bottom_nav_method_channel.dart';

abstract class CircularFabBottomNavPlatform extends PlatformInterface {
  /// Constructs a CircularFabBottomNavPlatform.
  CircularFabBottomNavPlatform() : super(token: _token);

  static final Object _token = Object();

  static CircularFabBottomNavPlatform _instance = MethodChannelCircularFabBottomNav();

  /// The default instance of [CircularFabBottomNavPlatform] to use.
  ///
  /// Defaults to [MethodChannelCircularFabBottomNav].
  static CircularFabBottomNavPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CircularFabBottomNavPlatform] when
  /// they register themselves.
  static set instance(CircularFabBottomNavPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
