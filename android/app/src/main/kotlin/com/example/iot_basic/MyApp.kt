package com.iot.basic

import android.app.Application
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.android.user.api.ILoginCallback
import com.thingclips.smart.android.common.utils.L

class MyApp : Application() {

    override fun onCreate() {
        super.onCreate()

        // TODO: Tuya SDK configuration - temporarily disabled
        // AppKey aur AppSecret (Tuya IoT Platform se proper credentials chahiye)
        // val APP_KEY = "tymr3dk4gfq5hsggawsf"
        // val APP_SECRET = "8q4markmxp3gry5n4we5nrxufmtdq7jw" 

        // ThingHomeSdk.init(this, APP_KEY, APP_SECRET)
        // ThingHomeSdk.setDebugMode(true)
    }
}
