package com.iot.basic.service

import com.thingclips.smart.sdk.api.IResultCallback
import com.thingclips.smart.android.user.api.IRegisterCallback
import com.thingclips.smart.android.user.api.ILoginCallback
import com.thingclips.smart.android.user.api.IResetPasswordCallback
import com.thingclips.smart.android.user.bean.User
import com.thingclips.smart.home.sdk.ThingHomeSdk


class AuthService {

    fun sendVerificationCode(
    email: String,
    phoneNo: String,
    countryCode: String,
    isEmailMode: Boolean,
    type: Int,
    callback: (Boolean, String) -> Unit
) {
    val userName = if (isEmailMode) email else phoneNo
    if (userName.isEmpty() || countryCode.isEmpty()) {
        callback(false, "Email/Phone or CountryCode is missing")
        return
    }

    ThingHomeSdk.getUserInstance().sendVerifyCodeWithUserName(
        userName,
        "",
        countryCode,
        type,
        object : IResultCallback {  // ✅ Correct callback
            override fun onError(code: String?, error: String?) {
                callback(false, error ?: "Unknown error")
            }

            override fun onSuccess() {
                callback(true, "Verification code sent successfully")
            }
        }
    )
}


    fun signup(
        email: String,
        phoneNo: String,
        countryCode: String,
        verificationCode: String,
        password: String,
        isEmailMode: Boolean,
        callback: (Boolean, String) -> Unit
    ) {
        if (isEmailMode) {
            ThingHomeSdk.getUserInstance().registerAccountWithEmail(
                countryCode,
                email,
                password,
                verificationCode,
                object : IRegisterCallback {
                    override fun onError(code: String?, error: String?) {
                        callback(false, error ?: "Registration failed")
                    }

                    override fun onSuccess(user: User?) {
                        callback(true, "User registered successfully with email")
                    }
                }
            )
        } else {
            ThingHomeSdk.getUserInstance().registerAccountWithPhone(
                countryCode,
                phoneNo,
                password,
                verificationCode,
                object : IRegisterCallback {
                    override fun onError(code: String?, error: String?) {
                        callback(false, error ?: "Registration failed")
                    }

                    override fun onSuccess(user: User?) {
                        callback(true, "User registered successfully with phone")
                    }
                }
            )
        }
    }

    fun login(
        email: String,
        phoneNo: String,
        password: String,
        countryCode: String,
        isEmailMode: Boolean,
        callback: (Boolean, String) -> Unit
    ) {
        if (isEmailMode) {
            ThingHomeSdk.getUserInstance().loginWithEmail(
                countryCode,
                email,
                password,
                object : ILoginCallback {
                    override fun onError(code: String?, error: String?) {
                        callback(false, error ?: "Login failed")
                    }

                    override fun onSuccess(user: User?) {
                        callback(true, "Login successful with email")
                    }
                }
            )
        } else {
            ThingHomeSdk.getUserInstance().loginWithPhone(
                countryCode,
                phoneNo,
                password,
                object : ILoginCallback {
                    override fun onError(code: String?, error: String?) {
                        callback(false, error ?: "Login failed")
                    }

                    override fun onSuccess(user: User?) {
                        callback(true, "Login successful with phone")
                    }
                }
            )
        }
    }

    fun resetPassword(
        email: String,
        phoneNo: String,
        countryCode: String,
        verificationCode: String,
        password: String,
        isEmailMode: Boolean,
        callback: (Boolean, String) -> Unit
    ) {
        if (isEmailMode) {
            ThingHomeSdk.getUserInstance().resetEmailPassword(
                countryCode,
                email,
                verificationCode,
                password,
                object : IResetPasswordCallback {
                    override fun onError(code: String?, error: String?) {
                        callback(false, error ?: "Reset password failed")
                    }

                    override fun onSuccess() {
                        callback(true, "Password reset successful with email")
                    }
                }
            )
        } else {
            ThingHomeSdk.getUserInstance().resetPhonePassword(
                countryCode,
                phoneNo,
                password,
                verificationCode,
                object : IResetPasswordCallback {
                    override fun onError(code: String?, error: String?) {
                        callback(false, error ?: "Reset password failed")
                    }

                    override fun onSuccess() {
                        callback(true, "Password reset successful with phone")
                    }
                }
            )
        }
    }
}
