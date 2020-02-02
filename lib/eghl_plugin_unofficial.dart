import 'dart:async';

import 'package:flutter/services.dart';

class EghlPluginUnofficial {
  static const MethodChannel _channel =
      const MethodChannel('eghl_plugin_unofficial');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
