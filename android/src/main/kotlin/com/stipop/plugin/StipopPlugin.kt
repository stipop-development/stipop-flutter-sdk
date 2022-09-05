package com.stipop.plugin

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.inputmethod.InputMethodManager
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.stipop.Stipop
import io.stipop.delegate.SPComponentLifeCycleDelegate
import io.stipop.delegate.StipopDelegate
import io.stipop.models.ComponentEnum
import io.stipop.models.LifeCycleEnum
import io.stipop.models.SPPackage
import io.stipop.models.SPSticker
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

/** StipopPlugin */
class StipopPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, StipopDelegate, SPComponentLifeCycleDelegate {

    companion object {
        var mChannel: MethodChannel? = null

        const val TAG_CONNECT = "connect"
        const val ARG_USER_ID = "userID"
        const val ARG_LANGUAGE = "languageCode"
        const val ARG_COUNTRY = "countryCode"

        const val TAG_SHOW = "show"

        const val TAG_HIDE = "hide"
    }

    private var mContext: Context? = null
    private var mActivity: FragmentActivity? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "stipop_plugin").apply {
            setMethodCallHandler(this@StipopPlugin)
        }
        mContext = flutterPluginBinding.applicationContext
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity as FragmentActivity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity as FragmentActivity
    }

    override fun onDetachedFromActivity() {
        mActivity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mContext = null
        mChannel?.setMethodCallHandler(null)
        mChannel = null
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
        when (call.method) {
            TAG_CONNECT -> {
                Stipop.setComponentLifeCycleDelegate(this)
                mActivity?.let {
                    Stipop.connect(it, userId!!, this, null, null, locale, taskCallBack = { isConnected ->
                        if(isConnected) {
                            result.success(true)
                        }
                    })
                } ?: kotlin.run {
                    result.success(false)
                }
            }

            TAG_SHOW -> {
                Stipop.show()
                result.success(true)
            }

            TAG_HIDE -> {
                Stipop.hide()
                result.success(true)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onStickerSingleTapped(sticker: SPSticker): Boolean {
        val arguments = HashMap<String, Any>()
        arguments.apply {
            arguments["packageId"] = sticker.packageId
            arguments["stickerId"] = sticker.stickerId
            sticker.stickerImg?.let { arguments.put("stickerImg", it) }
            sticker.stickerImgLocalFilePath?.let { arguments.put("stickerImgLocalFilePath", it) }
            arguments["favoriteYN"] = sticker.favoriteYN
            arguments["keyword"] = sticker.keyword
        }.run {
            mChannel?.invokeMethod("onStickerSingleTapped", this)
        }
        return true
    }

    override fun onStickerDoubleTapped(sticker: SPSticker): Boolean {
        val arguments = HashMap<String, Any>()
        arguments.apply {
            arguments["packageId"] = sticker.packageId
            arguments["stickerId"] = sticker.stickerId
            sticker.stickerImg?.let { arguments.put("stickerImg", it) }
            sticker.stickerImgLocalFilePath?.let { arguments.put("stickerImgLocalFilePath", it) }
            arguments["favoriteYN"] = sticker.favoriteYN
            arguments["keyword"] = sticker.keyword
        }.run {
            mChannel?.invokeMethod("onStickerDoubleTapped", this)
        }
        return true
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
                mChannel?.invokeMethod("onStickerPackRequested", this)
            }
        }
        return true
    }
    override fun spComponentLifeCycle(componentEnum: ComponentEnum, lifeCycleEnum: LifeCycleEnum) {
        when(componentEnum){
            ComponentEnum.PICKER_VIEW -> {
                when(lifeCycleEnum){
                    LifeCycleEnum.CREATED -> {
                        val arguments = HashMap<String, Any>()
                        arguments.apply {
                            arguments["isAppear"] = true
                        }.run {
                            StipopPlugin.mChannel?.invokeMethod("pickerViewIsAppear", this)
                        }
                    }
                    LifeCycleEnum.DESTROYED -> {
                        val arguments = HashMap<String, Any>()
                        arguments.apply {
                            arguments["isAppear"] = false
                        }.run {
                            StipopPlugin.mChannel?.invokeMethod("pickerViewIsAppear", this)
                        }
                    }
                }
            }
        }
    }
}
