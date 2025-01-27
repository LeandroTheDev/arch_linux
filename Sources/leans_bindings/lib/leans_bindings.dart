
import 'leans_bindings_platform_interface.dart';

class LeansBindings {
  Future<String?> getPlatformVersion() {
    return LeansBindingsPlatform.instance.getPlatformVersion();
  }
}
