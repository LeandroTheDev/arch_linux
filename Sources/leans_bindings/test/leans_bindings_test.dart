import 'package:flutter_test/flutter_test.dart';
import 'package:leans_bindings/leans_bindings.dart';
import 'package:leans_bindings/leans_bindings_platform_interface.dart';
import 'package:leans_bindings/leans_bindings_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLeansBindingsPlatform
    with MockPlatformInterfaceMixin
    implements LeansBindingsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LeansBindingsPlatform initialPlatform = LeansBindingsPlatform.instance;

  test('$MethodChannelLeansBindings is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLeansBindings>());
  });

  test('getPlatformVersion', () async {
    LeansBindings leansBindingsPlugin = LeansBindings();
    MockLeansBindingsPlatform fakePlatform = MockLeansBindingsPlatform();
    LeansBindingsPlatform.instance = fakePlatform;

    expect(await leansBindingsPlugin.getPlatformVersion(), '42');
  });
}
