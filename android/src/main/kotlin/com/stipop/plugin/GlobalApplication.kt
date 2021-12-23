package com.stipop.plugin

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDexApplication
import io.stipop.Stipop
class GlobalApplication : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()
        Stipop.configure(this)
    }
}
