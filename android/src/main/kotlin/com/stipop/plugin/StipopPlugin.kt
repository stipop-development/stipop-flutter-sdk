package com.stipop.plugin

import android.app.Activity
import android.content.Context
import android.view.inputmethod.InputMethodManager
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
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
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

/** StipopPlugin */
class StipopPlugin : FlutterPlugin, MethodCallHandler, StipopDelegate, ActivityAware {

    companion object {
        lateinit var channel: MethodChannel
        const val ARG_USER_ID = "userID"
        const val ARG_LANGUAGE = "languageCode"
        const val ARG_COUNTRY = "countryCode"
    }

    private lateinit var mContext: Context
    private lateinit var activity: FragmentActivity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "stipop_plugin")
        channel.setMethodCallHandler(this)
        mContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val languageCode = call.argument<String>(ARG_LANGUAGE)
        val countryCode = call.argument<String>(ARG_COUNTRY)
        val locale = if (languageCode != null && countryCode != null) {
            Locale(languageCode, countryCode)
        } else {
            Locale.getDefault()
        }
        val userId = call.argument<String>(ARG_USER_ID)
        if (call.method == "showKeyboard") {
            Stipop.connect(activity, userId!!, this, null, locale, taskCallBack = { isConnected ->
                when (isConnected) {
                    true -> Stipop.showKeyboard()
                }
            })
            result.success(true)
        } else if (call.method == "showSearch") {
            Stipop.connect(activity, userId!!, this, null, locale, taskCallBack = { isConnected ->
                when (isConnected) {
                    true -> Stipop.showSearch()
                }
            })
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
        val imm: InputMethodManager =
            mContext.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        if (imm.isActive)
            imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onStickerPackRequested(spPackage: SPPackage): Boolean {
        with(spPackage) {
            val arguments = HashMap<String, Any>()
            val stickers = ArrayList<HashMap<String, Any>>()
            for (sticker in spPackage.stickers) {
                val stickerArg = HashMap<String, Any>()
                stickerArg["packageId"] = sticker.packageId
                stickerArg["stickerId"] = sticker.stickerId
                sticker.stickerImg?.let { stickerArg.put("stickerImg", it) }
                sticker.stickerImgLocalFilePath?.let {
                    stickerArg.put(
                        "stickerImgLocalFilePath",
                        it
                    )
                }
                stickerArg["favoriteYN"] = sticker.favoriteYN
                stickerArg["keyword"] = sticker.keyword
                stickers.add(stickerArg)
            }
            arguments.apply {
                artistName?.let { arguments.put("artistName", it) }
                download?.let { arguments.put("download", it) }
                language?.let { arguments.put("language", it) }
                new?.let { arguments.put("new", it) }
                packageAnimated?.let { arguments.put("packageAnimated", it) }
                packageCategory?.let { arguments.put("packageCategory", it) }
                packageId.let { arguments.put("packageId", it) }
                packageImg?.let { arguments.put("packageImg", it) }
                packageKeywords?.let { arguments.put("packageKeywords", it) }
                packageName?.let { arguments.put("packageName", it) }
                wish?.let { arguments.put("wish", it) }
                view?.let { arguments.put("view", it) }
                order.let { arguments.put("order", it) }
                stickers.let { arguments.put("stickers", it) }
            }.run {
                channel.invokeMethod("onStickerPackRequested", this)
            }
        }
        return true
    }

    override fun onStickerSelected(sticker: SPSticker): Boolean {
        val arguments = HashMap<String, Any>()
        arguments.apply {
            arguments["packageId"] = sticker.packageId
            arguments["stickerId"] = sticker.stickerId
            sticker.stickerImg?.let { arguments.put("stickerImg", it) }
            sticker.stickerImgLocalFilePath?.let { arguments.put("stickerImgLocalFilePath", it) }
            arguments["favoriteYN"] = sticker.favoriteYN
            arguments["keyword"] = sticker.keyword
        }.run {
            channel.invokeMethod("onStickerSelected", this)
        }
        return true
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FragmentActivity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }
}
