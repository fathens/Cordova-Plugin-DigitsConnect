package org.fathens.cordova.plugin.twitterconnect

import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.json.JSONArray

import com.twitter.sdk.android.core.TwitterAuthConfig
import io.fabric.sdk.android.Fabric
import com.twitter.sdk.android.core.TwitterCore
import io.fabric.sdk.android.services.settings.IconRequest.build
import com.digits.sdk.android.Digits




public class DigitsConnect : CordovaPlugin() {

    override fun pluginInitialize() {
        val authConfig = TwitterAuthConfig(TWITTER_KEY, TWITTER_SECRET)
        Fabric.with(cordova.activity, TwitterCore(authConfig), Digits.Builder().build())
    }

}
