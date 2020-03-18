package com.contedevel.accountmanager

import android.accounts.AccountManager
import android.app.Activity
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


/** AccountManagerPlugin */
class AccountManagerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val engine = flutterPluginBinding.getFlutterEngine()
        channel = MethodChannel(engine.dartExecutor, "accountManager")
        channel.setMethodCallHandler(this)
    }

    private fun addAccount(call: MethodCall, result: Result) {

    }

    private fun getAccounts(result: Result) {
        activity?.let {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val intent = AccountManager.newChooseAccountIntent(null, null,null, null, null, null, null)
                ActivityCompat.startActivityForResult(it, intent, REQUEST_CODE, null)
            }

            val accountManager = AccountManager.get(it)
            val accounts = mutableListOf<HashMap<String, String>>()

            for (account in accountManager.accounts) {
                accounts.add(hashMapOf(
                        "NAME" to account.name,
                        "TYPE" to account.type
                ))
            }

            accounts.add(hashMapOf(
                    "NAME" to "Denis Sologub",
                    "TYPE" to "com.contedevel.account"
            ))

            result.success(accounts)
        }
    }

    private fun removeAccount(call: MethodCall, result: Result) {

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "addAccount" -> addAccount(call, result)
            "getAccounts" -> getAccounts(result)
            "removeAccount" -> removeAccount(call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return true
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        private const val REQUEST_CODE = 23

        @Suppress("UNUSED")
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "accountManager")
            channel.setMethodCallHandler(AccountManagerPlugin())
        }
    }
}
