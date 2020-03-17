package com.contedevel.accountmanager

import android.accounts.AbstractAccountAuthenticator
import android.accounts.Account
import android.accounts.AccountAuthenticatorResponse
import android.annotation.TargetApi
import android.content.Context
import android.os.Build
import android.os.Bundle

@TargetApi(Build.VERSION_CODES.ECLAIR)
open class FlutterAccountAuthenticator(context: Context): AbstractAccountAuthenticator(context) {

    override fun getAuthTokenLabel(authTokenType: String?): String {
        return ""
    }

    override fun confirmCredentials(response: AccountAuthenticatorResponse?, account: Account?,
                                    options: Bundle?): Bundle {
        return Bundle()
    }

    override fun updateCredentials(response: AccountAuthenticatorResponse?, account: Account?,
                                   authTokenType: String?, options: Bundle?): Bundle {
        return Bundle()
    }

    override fun getAuthToken(response: AccountAuthenticatorResponse?, account: Account?,
                              authTokenType: String?, options: Bundle?): Bundle {
        return Bundle()
    }

    override fun hasFeatures(response: AccountAuthenticatorResponse?, account: Account?,
                             features: Array<out String>?): Bundle {
        return Bundle()
    }

    override fun editProperties(response: AccountAuthenticatorResponse?,
                                accountType: String?): Bundle {
        return Bundle()
    }

    override fun addAccount(response: AccountAuthenticatorResponse?, accountType: String?,
                            authTokenType: String?, requiredFeatures: Array<out String>?,
                            options: Bundle?): Bundle {
        return Bundle()
    }
}