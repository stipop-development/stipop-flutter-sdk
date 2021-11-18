package com.stipop.stipop.stipop_plugin

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** StipopPlugin */
class StipopPlugin: FlutterPlugin, MethodCallHandler {
  companion object {
    lateinit var channel : MethodChannel
  }
  private lateinit var mContext : Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "stipop_plugin")
    channel.setMethodCallHandler(this)
    mContext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "showKeyboard") {
      val intent = Intent(mContext, StipopActivity::class.java)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      intent.putExtra("METHOD", "showKeyboard")
      mContext.startActivity(intent)
      result.success(true)
    } else if (call.method == "showSearch") {
      val intent = Intent(mContext, StipopActivity::class.java)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      intent.putExtra("METHOD", "showSearch")
      mContext.startActivity(intent)
      result.success(true)
    } else if (call.method == "hideKeyboard") {
      val intent = Intent(mContext, StipopActivity::class.java)
      intent.putExtra("METHOD", "hideKeyboard")
      mContext.startActivity(intent)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
