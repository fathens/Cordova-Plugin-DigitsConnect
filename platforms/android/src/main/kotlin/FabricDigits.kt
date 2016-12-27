package org.fathens.cordova.plugin.fabric

import org.apache.cordova.*
import org.json.*
import com.digits.sdk.android.*

class FabricDigits : CordovaPlugin(), SessionListener {

    private class PluginContext(val holder: FabricDigits, val action: String, val callback: CallbackContext) {
        fun error(msg: String?) = callback.error(msg)
        fun success() = callback.success(null as? String)
        fun success(msg: String?) = callback.success(msg)
        fun success(obj: JSONObject?) {
            if (obj != null) {
                callback.success(obj)
            } else {
                success()
            }
        }
    }

    private var context: PluginContext? = null

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        try {
            val method = javaClass.getMethod(action, args.javaClass)
            cordova.threadPool.execute {
                context = PluginContext(this, action, callbackContext)
                method.invoke(this, args)
            }
            return true
        } catch (e: NoSuchMethodException) {
            return false
        }
    }

    fun login(args: JSONArray) {
        val authConfig = AuthConfig.Builder().withAuthCallBack(object : AuthCallback {
            override fun success(session: DigitsSession, phoneNumber: String) {
                val auth = session.authToken
                val result = JSONObject(hashMapOf(
                        "token" to auth.token,
                        "secret" to auth.secret
                ))
                context?.success(result)
            }

            override fun failure(error: DigitsException) {
                context?.error(error.message)
            }
        })
        Digits.authenticate(authConfig.build())
    }

    public fun logout(args: JSONArray) {
        Digits.clearActiveSession()
    }

    public fun getToken(args: JSONArray) {
        if (Digits.getActiveSession().isValidUser) {
            val auth = Digits.getActiveSession().authToken
            val result = JSONObject(hashMapOf(
                    "token" to auth.token,
                    "secret" to auth.secret
            ))
            context?.success(result)
        } else {
            context?.success()
        }
    }

    override fun changed(newSession: DigitsSession?) {
        newSession?.let { session ->
            when (context?.action) {
                "logout" -> {
                    if (session.isValidUser) {
                        context?.error("still logged in")
                    } else {
                        context?.success()
                    }
                }
                else -> {
                    // Nothing to do
                }
            }

        }
    }
}
