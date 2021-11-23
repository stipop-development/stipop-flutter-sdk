package com.stipop.stipop.stipop_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.view.inputmethod.InputMethodManager
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.stipop.Stipop
import io.stipop.StipopDelegate
import io.stipop.models.SPPackage
import io.stipop.models.SPSticker

/** StipopPlugin */
class StipopPlugin: FlutterPlugin, MethodCallHandler, StipopDelegate, ActivityAware {
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
      Stipop.showKeyboard()
      result.success(true)
    } else if (call.method == "showSearch") {
      Stipop.showSearch()
      result.success(true)
    } else if (call.method == "hideKeyboard") {
      this.hideKeyboard()
      Stipop.hideKeyboard()
      result.success(true)
    } else {
      result.notImplemented()
    }
  }

  private fun hideKeyboard() {
    val imm: InputMethodManager = mContext.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
    if (imm.isActive)
      imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onStickerPackageRequested(spPackage: SPPackage): Boolean {
    var arguments = HashMap<String, Any>()
    spPackage.artistName?.let { arguments.put("artistName", it) }
    spPackage.download?.let { arguments.put("download", it) }
    spPackage.language?.let { arguments.put("language", it) }
    spPackage.new?.let { arguments.put("new", it) }
    spPackage.packageAnimated?.let { arguments.put("packageAnimated", it) }
    spPackage.packageCategory?.let { arguments.put("packageCategory", it) }
    arguments.put("packageId", spPackage.packageId)
    spPackage.packageImg?.let { arguments.put("packageImg", it) }
    spPackage.packageKeywords?.let { arguments.put("packageKeywords", it) }
    spPackage.packageName?.let { arguments.put("packageName", it) }
    spPackage.wish?.let { arguments.put("wish", it) }
    spPackage.view?.let { arguments.put("view", it) }
    arguments.put("order", spPackage.order)
    var stickers = ArrayList<HashMap<String, Any>>()
    for (sticker in spPackage.stickers) {
      var stickerArg = HashMap<String, Any>()
      stickerArg.put("packageId", sticker.packageId)
      stickerArg.put("stickerId", sticker.stickerId)
      sticker.stickerImg?.let { stickerArg.put("stickerImg", it) }
      sticker.stickerImgLocalFilePath?.let { stickerArg.put("stickerImgLocalFilePath", it) }
      stickerArg.put("favoriteYN", sticker.favoriteYN)
      stickerArg.put("keyword", sticker.keyword)
      stickers.add(stickerArg)
    }
    arguments.put("stickers", stickers)
    channel.invokeMethod("canDownload", arguments)
    return true
  }

  override fun onStickerSelected(sticker: SPSticker): Boolean {
    var arguments = HashMap<String, Any>()
    arguments.put("packageId", sticker.packageId)
    arguments.put("stickerId", sticker.stickerId)
    sticker.stickerImg?.let { arguments.put("stickerImg", it) }
    sticker.stickerImgLocalFilePath?.let { arguments.put("stickerImgLocalFilePath", it) }
    arguments.put("favoriteYN", sticker.favoriteYN)
    arguments.put("keyword", sticker.keyword)
    channel.invokeMethod("onStickerSelected", arguments)
    return true
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Stipop.Companion.connect(binding.activity, "stipop_user", this)
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivity() {

  }
}
