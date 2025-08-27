package com.iot.basic

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import com.thingclips.smart.sdk.api.IResultCallback
import com.thingclips.smart.android.user.api.IRegisterCallback
import com.thingclips.smart.android.user.bean.User
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.android.user.api.ILoginCallback


class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.iot.basic.channel"

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        try {

            val APP_KEY = "tymr3dk4gfq5hsggawsf"
            val APP_SECRET = "8q4markmxp3gry5n4we5nrxufmtdq7jw"

            ThingHomeSdk.init(application, APP_KEY, APP_SECRET)
            ThingHomeSdk.setDebugMode(true)

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "getVerificationCode" -> handleGetVerificationCode(call, result)
                        "signupWithVerificationCode" -> handleSignup(call, result)
                        "userLogin" -> handleUserLogin(call, result)
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("EXCEPTION", e.message, null)
                }
            }
    }


    private fun handleGetVerificationCode(call: MethodCall, result: MethodChannel.Result) {
        try {
            val email = call.argument<String>("email")
            val countryCode = call.argument<String>("countryCode")

            if (email.isNullOrEmpty() || countryCode.isNullOrEmpty()) {
                result.error("INVALID_PARAMS", "Email or country code is null", null)
            } else {
                sendTuyaVerificationCode(email, countryCode, result)
            }
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }

    private fun handleSignup(call: MethodCall, result: MethodChannel.Result) {
        try {
            val email = call.argument<String>("email")
            val countryCode = call.argument<String>("countryCode")
            val verificationCode = call.argument<String>("verificationCode")
            val password = call.argument<String>("password")

            if (email.isNullOrEmpty() || countryCode.isNullOrEmpty() ||
                verificationCode.isNullOrEmpty() || password.isNullOrEmpty()
            ) {
                result.error("INVALID_PARAMS", "Missing parameters", null)
            } else {
                signupWithVerificationCode(email, countryCode, verificationCode, password, result)
            }
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }

    private fun handleUserLogin(call: MethodCall, result: MethodChannel.Result) {
        try {
            val email = call.argument<String>("email")
            val password = call.argument<String>("password")
            val countryCode = call.argument<String>("countryCode")

            if (email.isNullOrEmpty() || password.isNullOrEmpty() || countryCode.isNullOrEmpty()) {
                result.error("INVALID_PARAMS", "Missing parameters", null)
            } else {
                userLogin(countryCode,email, password,  result)
            }
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }


    private fun sendTuyaVerificationCode(email: String, countryCode: String, result: MethodChannel.Result) {
        try {
            ThingHomeSdk.getUserInstance().sendVerifyCodeWithUserName(
                email,
                "", // phone number empty for email verification
                countryCode,
                1, // 1 = email verification
                object : IResultCallback {
                    override fun onError(code: String?, error: String?) {
                        result.error(code ?: "ERROR", error ?: "Unknown error", null)
                    }

                    override fun onSuccess() {
                        result.success("Verification code sent successfully")
                    }
                }
            )
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }

    private fun signupWithVerificationCode(
        email: String,
        countryCode: String,
        verificationCode: String,
        password: String,
        result: MethodChannel.Result
    ) {
        try {
            ThingHomeSdk.getUserInstance().registerAccountWithEmail(
                countryCode,
                email,
                password,
                verificationCode,
                object : IRegisterCallback {
                    override fun onError(code: String?, error: String?) {
                        result.error(code ?: "ERROR", error ?: "Registration failed", null)
                    }

                    override fun onSuccess(user: User?) {
                        result.success("User registered successfully")
                    }
                }
            )
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }

    private fun userLogin( countryCode: String, email: String, password: String, result: MethodChannel.Result){
        try{
            ThingHomeSdk.getUserInstance().loginWithEmail( countryCode,email, password, object : ILoginCallback {
                override fun onError(code: String?, error: String?) {
                    result.error(code ?: "ERROR", error ?: "Login failed", null)
                }

                override fun onSuccess(user: User?) {
                    result.success("Login successful")
                }
            })
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }

    override fun onDestroy() {
        try {
            super.onDestroy()
            ThingHomeSdk.onDestroy()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
