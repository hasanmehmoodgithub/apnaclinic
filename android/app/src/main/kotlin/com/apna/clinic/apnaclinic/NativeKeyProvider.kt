package com.apna.clinic.apnaclinic

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Stable app secret for Flutter [EncryptionService].
 *
 * AndroidKeyStore AES keys cannot export raw bytes, so a random secret is
 * generated once and wrapped with a Keystore AES-GCM key.
 */
object NativeKeyProvider {
    private const val ANDROID_KEYSTORE = "AndroidKeyStore"
    private const val WRAP_ALIAS = "apna_clinic_native_wrap"
    private const val PREFS_NAME = "native_key_store"
    private const val PREF_CIPHERTEXT = "wrapped_key"
    private const val PREF_IV = "wrapped_iv"
    private const val GCM_TAG_BITS = 128
    private const val KEY_BYTES = 32
    private const val TRANSFORMATION = "AES/GCM/NoPadding"

    fun getSecretKey(context: Context): String {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val ciphertext = prefs.getString(PREF_CIPHERTEXT, null)
        val iv = prefs.getString(PREF_IV, null)
        if (!ciphertext.isNullOrEmpty() && !iv.isNullOrEmpty()) {
            return unwrap(ciphertext, iv)
        }

        val secret = generateSecret()
        val wrapped = wrap(secret)
        prefs.edit()
            .putString(PREF_CIPHERTEXT, wrapped.first)
            .putString(PREF_IV, wrapped.second)
            .apply()
        return secret
    }

    private fun generateSecret(): String {
        val bytes = ByteArray(KEY_BYTES)
        SecureRandom().nextBytes(bytes)
        return Base64.encodeToString(bytes, Base64.NO_WRAP)
    }

    private fun wrappingKey(): SecretKey {
        val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
        val existing = keyStore.getEntry(WRAP_ALIAS, null) as? KeyStore.SecretKeyEntry
        if (existing != null) {
            return existing.secretKey
        }
        return try {
            generateWrappingKey(strongBox = true)
        } catch (_: Exception) {
            generateWrappingKey(strongBox = false)
        }
    }

    private fun generateWrappingKey(strongBox: Boolean): SecretKey {
        val keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            ANDROID_KEYSTORE,
        )
        val spec = KeyGenParameterSpec.Builder(
            WRAP_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .setRandomizedEncryptionRequired(true)
            .setIsStrongBoxBacked(strongBox)
            .build()
        keyGenerator.init(spec)
        return keyGenerator.generateKey()
    }

    private fun wrap(secret: String): Pair<String, String> {
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, wrappingKey())
        val encrypted = cipher.doFinal(secret.toByteArray(Charsets.UTF_8))
        return Base64.encodeToString(encrypted, Base64.NO_WRAP) to
            Base64.encodeToString(cipher.iv, Base64.NO_WRAP)
    }

    private fun unwrap(ciphertext: String, iv: String): String {
        val cipher = Cipher.getInstance(TRANSFORMATION)
        val spec = GCMParameterSpec(GCM_TAG_BITS, Base64.decode(iv, Base64.NO_WRAP))
        cipher.init(Cipher.DECRYPT_MODE, wrappingKey(), spec)
        val decrypted = cipher.doFinal(Base64.decode(ciphertext, Base64.NO_WRAP))
        return String(decrypted, Charsets.UTF_8)
    }
}
