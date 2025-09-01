package com.iot.basic

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.iot.basic.service.AuthService
import com.iot.basic.ChannelConstants
import com.thingclips.smart.home.sdk.ThingHomeSdk

class MainActivity : FlutterActivity() {

    private val authService = AuthService()

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        val APP_KEY = "tymr3dk4gfq5hsggawsf"
        val APP_SECRET = "8q4markmxp3gry5n4we5nrxufmtdq7jw"

        ThingHomeSdk.init(application, APP_KEY, APP_SECRET)
        ThingHomeSdk.setDebugMode(true)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ChannelConstants.CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {

                        // Send Verification Code
                        ChannelConstants.METHOD_GET_VERIFICATION_CODE -> {
                            val email = call.argument<String>("email") ?: ""
                            val phoneNo = call.argument<String>("phoneNo") ?: ""
                            val isEmailMode = call.argument<Boolean>("isEmailMode") ?: true
                            val countryCode = call.argument<String>("countryCode") ?: ""
                            val type = call.argument<Int>("type") ?: 1

                            if ((isEmailMode && email.isEmpty()) ||
                                (!isEmailMode && phoneNo.isEmpty()) ||
                                countryCode.isEmpty()
                            ) {
                                result.error("INVALID_PARAMS", "Missing email/phone or countryCode", null)
                            } else {
                                authService.sendVerificationCode(
                                    email,
                                    phoneNo,
                                    countryCode,
                                    isEmailMode,
                                    type
                                ) { success, msg ->
                                    if (success) result.success(msg)
                                    else result.error("ERROR", msg, null)
                                }
                            }
                        }

                        // Signup
                        ChannelConstants.METHOD_SIGNUP -> {
                            val email = call.argument<String>("email") ?: ""
                            val phoneNo = call.argument<String>("phoneNo") ?: ""
                            val countryCode = call.argument<String>("countryCode") ?: ""
                            val verificationCode = call.argument<String>("verificationCode") ?: ""
                            val password = call.argument<String>("password") ?: ""
                            val isEmailMode = call.argument<Boolean>("isEmailMode") ?: true

                            if ((isEmailMode && email.isEmpty()) ||
                                (!isEmailMode && phoneNo.isEmpty()) ||
                                countryCode.isEmpty() ||
                                verificationCode.isEmpty() ||
                                password.isEmpty()
                            ) {
                                result.error("INVALID_PARAMS", "Missing signup parameters", null)
                            } else {
                                authService.signup(
                                    email,
                                    phoneNo,
                                    countryCode,
                                    verificationCode,
                                    password,
                                    isEmailMode
                                ) { success, msg ->
                                    if (success) result.success(msg)
                                    else result.error("ERROR", msg, null)
                                }
                            }
                        }

                        // Login
                        ChannelConstants.METHOD_LOGIN -> {
                            val email = call.argument<String>("email") ?: ""
                            val phoneNo = call.argument<String>("phoneNo") ?: ""
                            val password = call.argument<String>("password") ?: ""
                            val countryCode = call.argument<String>("countryCode") ?: ""
                            val isEmailMode = call.argument<Boolean>("isEmailMode") ?: true

                            if ((isEmailMode && email.isEmpty()) ||
                                (!isEmailMode && phoneNo.isEmpty()) ||
                                password.isEmpty() ||
                                countryCode.isEmpty()
                            ) {
                                result.error("INVALID_PARAMS", "Missing login parameters", null)
                            } else {
                                authService.login(
                                    email,
                                    phoneNo,
                                    password,
                                    countryCode,
                                    isEmailMode
                                ) { success, msg ->
                                    if (success) result.success(msg)
                                    else result.error("ERROR", msg, null)
                                }
                            }
                        }
                        ChannelConstants.METHOD_RESET_PASSWORD -> {
                            val email = call.argument<String>("email") ?: ""
                            val phoneNo = call.argument<String>("phoneNo") ?: ""
                            val countryCode = call.argument<String>("countryCode") ?: ""
                            val verificationCode = call.argument<String>("verificationCode") ?: ""
                            val password = call.argument<String>("password") ?: ""
                            val isEmailMode = call.argument<Boolean>("isEmailMode") ?: true

                            if ((isEmailMode && email.isEmpty()) ||
                                (!isEmailMode && phoneNo.isEmpty()) ||
                                countryCode.isEmpty() ||
                                verificationCode.isEmpty() ||
                                password.isEmpty()
                            ) {
                                result.error("INVALID_PARAMS", "Missing reset password parameters", null)
                            } else {
                                authService.resetPassword(
                                    email,
                                    phoneNo,
                                    countryCode,
                                    verificationCode,
                                    password,
                                    isEmailMode
                                ) { success, msg ->
                                    if (success) result.success(msg)
                                    else result.error("ERROR", msg, null)
                                }
                            }
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("EXCEPTION", e.message, null)
                }
            }
    }

    override fun onDestroy() {
        super.onDestroy()
        ThingHomeSdk.onDestroy()
    }
}
