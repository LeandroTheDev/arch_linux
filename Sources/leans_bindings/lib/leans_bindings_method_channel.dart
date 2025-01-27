import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'leans_bindings_platform_interface.dart';

/// An implementation of [LeansBindingsPlatform] that uses method channels.
class MethodChannelLeansBindings extends LeansBindingsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('leans_bindings');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
