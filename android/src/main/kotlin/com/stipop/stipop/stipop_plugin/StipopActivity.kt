package com.stipop.stipop.stipop_plugin

import android.app.Activity
import android.graphics.Rect
import android.os.Bundle
import android.os.Handler
import android.view.View
import android.view.ViewTreeObserver
import android.view.Window
import android.view.inputmethod.InputMethodManager
import androidx.appcompat.app.AppCompatActivity
import io.stipop.Stipop
import io.stipop.StipopDelegate
import io.stipop.custom.StipopImageView
import io.stipop.models.SPPackage
import io.stipop.models.SPSticker


class StipopActivity : AppCompatActivity(), StipopDelegate {
    private lateinit var keyboardVisibilityUtils: KeyboardVisibilityUtils
    private var method: String? = null
    private var isKeyboard = false
    private var isSearch = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        method = intent.getStringExtra("METHOD")

        setContentView(R.layout.layout_stipop)

        val stipopIV = findViewById<StipopImageView>(R.id.stipopIV)
        Stipop.connect(this, stipopIV, "stipop_user", "ko", "KR", this)

        val background = findViewById<View>(R.id.background)
        background.setOnClickListener {
            if (isKeyboard) {
                this.hideKeyboard()
            } else {
                this.finishActivity()
            }

        }

        keyboardVisibilityUtils = KeyboardVisibilityUtils(window,
                onShowKeyboard = {
                },
                onHideKeyboard = {
                    this.finishActivity()
                }
        )

        val handler = Handler()
        handler.postDelayed({
            // do something after 1000ms
            runOnUiThread {
                if (method.equals("showKeyboard")) {
                    isKeyboard = true
                    Stipop.showKeyboard()
                } else if (method.equals("showSearch")) {
                    isSearch = true
                    Stipop.showSearch()
                } else {
                    Stipop.hideKeyboard()
                }

            }
        }, 1000)
    }

    override fun onResume() {
        super.onResume()
        if (isSearch) {
            this.finishActivity()
        }
    }

    fun hideKeyboard() {
        val imm: InputMethodManager = getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        if (imm.isActive)
            imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0)
    }

    private fun finishActivity() {
        this.finish()
    }

    override fun canDownload(spPackage: SPPackage): Boolean {

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

        StipopPlugin.channel.invokeMethod("canDownload", arguments)
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
        StipopPlugin.channel.invokeMethod("onStickerSelected", arguments)
        if (!isKeyboard) {
            finishActivity()
        }
        return true
    }
}

class KeyboardVisibilityUtils(
        private val window: Window,
        //private val onShowKeyboard: ((keyboardHeight: Int) -> Unit)? = null,
        private val onShowKeyboard: (() -> Unit)? = null,
        private val onHideKeyboard: (() -> Unit)? = null
) {

    private val MIN_KEYBOARD_HEIGHT_PX = 150

    private val windowVisibleDisplayFrame = Rect()
    private var lastVisibleDecorViewHeight: Int = 0


    private val onGlobalLayoutListener = ViewTreeObserver.OnGlobalLayoutListener {
        window.decorView.getWindowVisibleDisplayFrame(windowVisibleDisplayFrame)
        val visibleDecorViewHeight = windowVisibleDisplayFrame.height()

        // Decide whether keyboard is visible from changing decor view height.
        if (lastVisibleDecorViewHeight != 0) {
            if (lastVisibleDecorViewHeight > visibleDecorViewHeight + MIN_KEYBOARD_HEIGHT_PX) {
                // Calculate current keyboard height (this includes also navigation bar height when in fullscreen mode).
                //val currentKeyboardHeight = window.decorView.height - windowVisibleDisplayFrame.bottom
                // Notify listener about keyboard being shown.
                //onShowKeyboard?.invoke(currentKeyboardHeight)
                onShowKeyboard?.invoke()
            } else if (lastVisibleDecorViewHeight + MIN_KEYBOARD_HEIGHT_PX < visibleDecorViewHeight) {
                // Notify listener about keyboard being hidden.
                onHideKeyboard?.invoke()
            }
        }
        // Save current decor view height for the next call.
        lastVisibleDecorViewHeight = visibleDecorViewHeight
    }

    init {
        window.decorView.viewTreeObserver.addOnGlobalLayoutListener(onGlobalLayoutListener)
    }

    fun detachKeyboardListeners() {
        window.decorView.viewTreeObserver.removeOnGlobalLayoutListener(onGlobalLayoutListener)
    }
}
