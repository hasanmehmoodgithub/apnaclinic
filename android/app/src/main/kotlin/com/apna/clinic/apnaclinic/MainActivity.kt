package com.apna.clinic.apnaclinic

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURITY_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkRoot" ->
                    result.success(DeviceSecurityChecker.isRooted(this))
                "checkEmulator" ->
                    result.success(DeviceSecurityChecker.isEmulator())
                "checkDeveloperMode" ->
                    result.success(DeviceSecurityChecker.isDeveloperModeEnabled(this))
                "checkAppIntegrity" ->
                    result.success(DeviceSecurityChecker.isAppTampered(this))
                else -> result.notImplemented()
            }
        }

        // Obfuscated channel names expected by SecurityService.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ADVANCED_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "a1" -> result.success(DeviceSecurityChecker.isRooted(this))
                "b1" -> result.success(DeviceSecurityChecker.isEmulator())
                "c1" ->
                    result.success(DeviceSecurityChecker.isDeveloperModeEnabled(this))
                "d1" -> result.success(DeviceSecurityChecker.isFridaPresent())
                "e1" -> result.success(DeviceSecurityChecker.isXposedPresent(this))
                "f1" -> result.success(DeviceSecurityChecker.isAppTampered(this))
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EXTERNAL_APP_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openInstalledApp" -> {
                    val packageName = call.argument<String>("androidPackage")
                    if (packageName.isNullOrBlank()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
                    if (launchIntent != null) {
                        startActivity(launchIntent)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private const val SECURITY_CHANNEL = "security_channel"
        private const val ADVANCED_CHANNEL = "qwe_rty_123"
        private const val EXTERNAL_APP_CHANNEL = "apna_clinic/external_app"
    }
}
