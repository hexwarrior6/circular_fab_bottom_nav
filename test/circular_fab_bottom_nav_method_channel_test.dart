import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circular_fab_bottom_nav/circular_fab_bottom_nav_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCircularFabBottomNav platform = MethodChannelCircularFabBottomNav();
  const MethodChannel channel = MethodChannel('circular_fab_bottom_nav');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
