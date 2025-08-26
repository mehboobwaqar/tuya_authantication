package com.iot.basic

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.thingclips.smart.sdk.api.IResultCallback
import com.thingclips.smart.home.sdk.ThingHomeSdk

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.iot.basic.channel"

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        // Tuya SDK credentials
        val APP_KEY = "tymr3dk4gfq5hsggawsf"
        val APP_SECRET = "8q4markmxp3gry5n4we5nrxufmtdq7jw"

        ThingHomeSdk.init(application, APP_KEY, APP_SECRET)

        ThingHomeSdk.setDebugMode(true)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            when (call.method) {

                "getVerificationCode" -> {
                    val email = call.argument<String>("email")
                    val countryCode = call.argument<String>("countryCode")

                    if (email.isNullOrEmpty() || countryCode.isNullOrEmpty()) {
                        result.error("INVALID_PARAMS", "Email or country code is null", null)
                    } else {
                        sendTuyaVerificationCode(email, countryCode, result)
                    }
                }

               "signupWithVerificationCode" -> {
    val email = call.argument<String>("email")
    val countryCode = call.argument<String>("countryCode")
    val verificationCode = call.argument<String>("verificationCode")
    val password = call.argument<String>("password")

    if (email.isNullOrEmpty() || countryCode.isNullOrEmpty() || 
        verificationCode.isNullOrEmpty() || password.isNullOrEmpty()) {
        result.error("INVALID_PARAMS", "Missing parameters", null)
    } else {
        signupWithVerificationCode(email, countryCode, verificationCode, password, result)
    }
}


                else -> result.notImplemented()
            }
        }
    }

    private fun sendTuyaVerificationCode(email: String, countryCode: String, result: MethodChannel.Result) {
        ThingHomeSdk.getUserInstance().sendVerifyCodeWithUserName(
            email,
            "", // phone number empty for email verification
            countryCode,
            1, // 1=email verification
            object : IResultCallback {
                override fun onError(code: String?, error: String?) {
                    result.error(code ?: "ERROR", error ?: "Unknown error", null)
                }

                override fun onSuccess() {
                    result.success("Verification code sent")
                }
            }
        )
    }
    private fun signupWithVerificationCode(
    email: String,
    countryCode: String,
    verificationCode: String,
    password: String,
    result: MethodChannel.Result
) {
    // Step 1: verify code
    ThingHomeSdk.getUserInstance().checkCodeWithUserName(
        email,
        verificationCode,
        countryCode,
        object : IResultCallback {
            override fun onError(code: String?, error: String?) {
                result.error(code ?: "ERROR", error ?: "Verification failed", null)
            }

            override fun onSuccess() {
                // Step 2: register user
                ThingHomeSdk.getUserInstance().registerAccountWithEmail(
                    email,
                    password,
                    countryCode,
                    verificationCode,
                    object : IResultCallback {
                        override fun onError(code: String?, error: String?) {
                            result.error(code ?: "ERROR", error ?: "Registration failed", null)
                        }

                        override fun onSuccess() {
                            result.success("User registered successfully")
                        }
                    }
                )
            }
        }
    )
}


    override fun onDestroy() {
        super.onDestroy()
        // Destroy cloud connection when app exits
        ThingHomeSdk.onDestroy()
    }
}
