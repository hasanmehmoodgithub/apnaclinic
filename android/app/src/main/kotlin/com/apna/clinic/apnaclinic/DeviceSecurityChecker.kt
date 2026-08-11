package com.apna.clinic.apnaclinic

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.net.InetSocketAddress
import java.net.Socket

/**
 * Device integrity heuristics used by Flutter [SecurityService] MethodChannels.
 */
object DeviceSecurityChecker {

    fun isRooted(context: Context): Boolean {
        return hasSuBinary() ||
            hasRootManagementApps(context) ||
            hasDangerousSystemProps() ||
            canExecuteSu()
    }

    fun isEmulator(): Boolean {
        val fingerprint = Build.FINGERPRINT.lowercase()
        val model = Build.MODEL.lowercase()
        val manufacturer = Build.MANUFACTURER.lowercase()
        val brand = Build.BRAND.lowercase()
        val device = Build.DEVICE.lowercase()
        val product = Build.PRODUCT.lowercase()
        val hardware = Build.HARDWARE.lowercase()

        return fingerprint.contains("generic") ||
            fingerprint.contains("unknown") ||
            model.contains("google_sdk") ||
            model.contains("emulator") ||
            model.contains("android sdk built for") ||
            manufacturer.contains("genymotion") ||
            (brand.startsWith("generic") && device.startsWith("generic")) ||
            product.contains("sdk") ||
            product.contains("google_sdk") ||
            product.contains("sdk_gphone") ||
            product.contains("vbox") ||
            hardware.contains("goldfish") ||
            hardware.contains("ranchu") ||
            Build.BOARD.lowercase().contains("nova")
    }

    fun isDeveloperModeEnabled(context: Context): Boolean {
        return try {
            Settings.Global.getInt(
                context.contentResolver,
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
                0,
            ) != 0
        } catch (_: Exception) {
            false
        }
    }

    fun isFridaPresent(): Boolean {
        val fridaFiles = listOf(
            "/data/local/tmp/frida-server",
            "/data/local/tmp/re.frida.server",
            "/sdcard/frida-server",
        )
        if (fridaFiles.any { File(it).exists() }) return true

        val suspiciousLibs = listOf("frida", "gadget")
        val maps = File("/proc/self/maps")
        if (maps.exists()) {
            try {
                maps.bufferedReader().useLines { lines ->
                    for (line in lines) {
                        val lower = line.lowercase()
                        if (suspiciousLibs.any { lower.contains(it) }) return true
                    }
                }
            } catch (_: Exception) {
                // ignore
            }
        }

        // Default Frida server port
        return canConnectLocally(27042)
    }

    fun isXposedPresent(context: Context): Boolean {
        val xposedPaths = listOf(
            "/system/framework/XposedBridge.jar",
            "/system/bin/app_process.orig",
            "/system/xposed.prop",
        )
        if (xposedPaths.any { File(it).exists() }) return true

        return try {
            val packages = listOf(
                "de.robv.android.xposed.installer",
                "org.meowcat.edxposed.manager",
                "com.solohsu.android.edxp.manager",
                "io.github.lsposed.manager",
            )
            packages.any { isPackageInstalled(context, it) }
        } catch (_: Exception) {
            false
        }
    }

    fun isAppTampered(context: Context): Boolean {
        // Keep false for now: FLAG_DEBUGGABLE alone would flag normal debug
        // installs, and BuildConfig is not enabled in this Gradle module.
        return false
    }

    private fun hasSuBinary(): Boolean {
        val paths = listOf(
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/system/su",
            "/system/bin/.ext/.su",
            "/system/usr/we-need-root/su-backup",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/data/local/su",
        )
        return paths.any { File(it).exists() }
    }

    private fun hasRootManagementApps(context: Context): Boolean {
        val packages = listOf(
            "com.noshufou.android.su",
            "com.noshufou.android.su.elite",
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "com.thirdparty.superuser",
            "com.yellowes.su",
            "com.topjohnwu.magisk",
        )
        return packages.any { isPackageInstalled(context, it) }
    }

    private fun hasDangerousSystemProps(): Boolean {
        val tags = Build.TAGS
        if (tags != null && tags.contains("test-keys")) return true
        return readProp("ro.debuggable") == "1" || readProp("ro.secure") == "0"
    }

    private fun canExecuteSu(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("which", "su"))
            BufferedReader(InputStreamReader(process.inputStream)).use { reader ->
                reader.readLine() != null
            }
        } catch (_: Exception) {
            false
        }
    }

    private fun readProp(key: String): String? {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("/system/bin/getprop", key))
            BufferedReader(InputStreamReader(process.inputStream)).use { it.readLine() }
        } catch (_: Exception) {
            null
        }
    }

    private fun isPackageInstalled(context: Context, packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (_: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun canConnectLocally(port: Int): Boolean {
        return try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress("127.0.0.1", port), 150)
                true
            }
        } catch (_: Exception) {
            false
        }
    }
}
