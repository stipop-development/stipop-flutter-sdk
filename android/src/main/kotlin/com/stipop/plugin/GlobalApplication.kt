package com.stipop.plugin

import androidx.multidex.MultiDexApplication
import io.stipop.Stipop

class GlobalApplication : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()
        Stipop.configure(this)
    }
}
