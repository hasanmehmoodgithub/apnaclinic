# Flutter embedding / plugins (plugin consumer-rules are also merged).
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Native MethodChannel entry and BuildConfig cert hashes.
-keep class com.apna.clinic.apnaclinic.MainActivity { *; }
-keep class com.apna.clinic.apnaclinic.DeviceSecurityChecker { *; }
-keep class com.apna.clinic.apnaclinic.BuildConfig { *; }

# Crash traces stay useful without exposing original file names.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
