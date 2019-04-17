import 'dart:async';

import 'package:flutter/services.dart';

class EghlPluginUnofficial {
  static const MethodChannel _channel =
      const MethodChannel('eghl_plugin_unofficial');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> makePayment(Map<String, String> params) async {
    final String result = await _channel.invokeMethod('makePayment', params);
    return result;
  }
}
