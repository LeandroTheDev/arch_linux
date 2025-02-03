//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <leans_bindings/leans_bindings_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) leans_bindings_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "LeansBindingsPlugin");
  leans_bindings_plugin_register_with_registrar(leans_bindings_registrar);
}
