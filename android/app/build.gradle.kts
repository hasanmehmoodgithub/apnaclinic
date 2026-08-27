import java.io.FileInputStream
import java.security.KeyStore
import java.security.MessageDigest
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

fun signingProp(key: String, env: String): String? {
    return keystoreProperties.getProperty(key)?.trim()?.takeIf { it.isNotEmpty() }
        ?: System.getenv(env)?.trim()?.takeIf { it.isNotEmpty() }
}

val uploadStorePassword = signingProp("storePassword", "UPLOAD_STORE_PASSWORD")
val uploadKeyPassword = signingProp("keyPassword", "UPLOAD_KEY_PASSWORD")
val uploadKeyAlias = signingProp("keyAlias", "UPLOAD_KEY_ALIAS")
val uploadStoreFileName = signingProp("storeFile", "UPLOAD_STORE_FILE") ?: "econceptions.jks"
val uploadStoreFile = file(uploadStoreFileName)
val hasUploadSigning = !uploadStorePassword.isNullOrEmpty() &&
    !uploadKeyPassword.isNullOrEmpty() &&
    !uploadKeyAlias.isNullOrEmpty() &&
    uploadStoreFile.exists()

android {
    namespace = "com.apna.clinic.apnaclinic"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.apna.clinic.android"
        minSdk = 28 // Android 9
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        buildConfigField("String", "EXPECTED_CERT_SHA256", "\"\"")
        buildConfigField("String", "EXPECTED_CERT_EXTRA", "\"${extraExpectedCerts()}\"")
    }

    signingConfigs {
        if (hasUploadSigning) {
            create("release") {
                keyAlias = uploadKeyAlias!!
                keyPassword = uploadKeyPassword!!
                storePassword = uploadStorePassword!!
                storeFile = uploadStoreFile
            }
        }
    }

    buildTypes {
        debug {
            val sha = signingCertSha256(signingConfigs.getByName("debug"))
            buildConfigField("String", "EXPECTED_CERT_SHA256", "\"$sha\"")
        }
        release {
            val releaseSigning = if (hasUploadSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            signingConfig = releaseSigning
            val sha = signingCertSha256(releaseSigning)
            buildConfigField("String", "EXPECTED_CERT_SHA256", "\"$sha\"")
            // R8 enabled while DexGuard is temporarily disabled.
            // When re-enabling DexGuard, set both back to false and restore the dexguard { } block.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

/** SHA-256 of the public cert used to sign this variant. Not a private key. */
fun signingCertSha256(config: com.android.build.api.dsl.ApkSigningConfig): String {
    val storeFile = config.storeFile ?: return ""
    val storePassword = config.storePassword ?: return ""
    val keyAlias = config.keyAlias ?: return ""
    if (!storeFile.exists()) return ""

    val bytes = storeFile.readBytes()
    val password = storePassword.toCharArray()

    fun load(type: String): KeyStore {
        val keyStore = KeyStore.getInstance(type)
        keyStore.load(bytes.inputStream(), password)
        return keyStore
    }

    val keyStore = try {
        load("JKS")
    } catch (_: Exception) {
        load("PKCS12")
    }
    val cert = keyStore.getCertificate(keyAlias) ?: return ""
    val digest = MessageDigest.getInstance("SHA-256").digest(cert.encoded)
    return digest.joinToString("") { "%02x".format(it) }
}

/**
 * Extra allow-listed cert SHA-256 hex values (Play App Signing, upload key).
 * Set `CERT_SHA256_PLAY`, `CERT_SHA256_RELEASE`, and/or comma-separated `CERT_SHA256_EXTRA`.
 */
fun extraExpectedCerts(): String {
    val values = mutableListOf<String>()
    System.getenv("CERT_SHA256_PLAY")?.trim()?.takeIf { it.isNotEmpty() }?.let(values::add)
    System.getenv("CERT_SHA256_RELEASE")?.trim()?.takeIf { it.isNotEmpty() }?.let(values::add)
    System.getenv("CERT_SHA256_EXTRA")
        ?.split(",")
        ?.map { it.trim() }
        ?.filter { it.isNotEmpty() }
        ?.let(values::addAll)
    return values.joinToString(",")
}
