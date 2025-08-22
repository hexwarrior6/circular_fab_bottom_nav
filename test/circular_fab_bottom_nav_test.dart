import 'package:flutter_test/flutter_test.dart';
import 'package:circular_fab_bottom_nav/circular_fab_bottom_nav.dart';
import 'package:circular_fab_bottom_nav/circular_fab_bottom_nav_platform_interface.dart';
import 'package:circular_fab_bottom_nav/circular_fab_bottom_nav_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCircularFabBottomNavPlatform
    with MockPlatformInterfaceMixin
    implements CircularFabBottomNavPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CircularFabBottomNavPlatform initialPlatform = CircularFabBottomNavPlatform.instance;

  test('$MethodChannelCircularFabBottomNav is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCircularFabBottomNav>());
  });
}
