#include "include/circular_fab_bottom_nav/circular_fab_bottom_nav_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "circular_fab_bottom_nav_plugin.h"

void CircularFabBottomNavPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  circular_fab_bottom_nav::CircularFabBottomNavPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
