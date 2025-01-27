import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'leans_bindings_method_channel.dart';

abstract class LeansBindingsPlatform extends PlatformInterface {
  /// Constructs a LeansBindingsPlatform.
  LeansBindingsPlatform() : super(token: _token);

  static final Object _token = Object();

  static LeansBindingsPlatform _instance = MethodChannelLeansBindings();

  /// The default instance of [LeansBindingsPlatform] to use.
  ///
  /// Defaults to [MethodChannelLeansBindings].
  static LeansBindingsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LeansBindingsPlatform] when
  /// they register themselves.
  static set instance(LeansBindingsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
