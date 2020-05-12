import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:d_platform_pro_sdk/d_platform_pro_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('d_platform_pro_sdk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {

  });
}
