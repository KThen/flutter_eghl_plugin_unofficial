package me.kthen.eghlpluginunofficial;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Activity;
import android.content.Intent;

/** EghlPluginUnofficialPlugin */
public class EghlPluginUnofficialPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  private Activity _activity;
  private eGHLPay _eghlPay;

  private EghlPluginUnofficialPlugin(Activity activity) {
    this._activity = activity;
    this._eghlPay = new eGHLPay(this._activity);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "eghl_plugin_unofficial");
    EghlPluginUnofficialPlugin plugin = new EghlPluginUnofficialPlugin(registrar.activity());
    registrar.addActivityResultListener(plugin);
    channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    this._eghlPay.onMethodCall(call, result);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    this._eghlPay.onActivityResult(requestCode, resultCode, data);
    return false;
  }
}
