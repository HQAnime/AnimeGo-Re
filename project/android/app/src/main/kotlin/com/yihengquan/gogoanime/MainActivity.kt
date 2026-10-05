package com.yihengquan.gogoanime

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val nativeChannel = "com.yihengquan.gogoanime"
    private val webRequestCode = 1111
    private var methodResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Bridge used to run the Cloudflare challenge in a real WebView and
        // hand the resulting cookie back to Flutter.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, nativeChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getCookie" -> {
                        methodResult = result
                        val link = call.argument<String>("link")
                        val dark = call.argument<Boolean>("dark") ?: false
                        if (link == null) {
                            result.error("invalid_link", "A link is required", null)
                        } else {
                            bypassBrowserCheck(link, dark)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == webRequestCode) {
            val cookie = data?.getStringExtra("cookie")
            val agent = data?.getStringExtra("agent")
            methodResult?.success(listOf(cookie, agent))
        }
    }

    private fun bypassBrowserCheck(link: String, dark: Boolean) {
        val webIntent = Intent(this, WebActivity::class.java)
        webIntent.putExtra("link", link)
        webIntent.putExtra("dark", dark)
        startActivityForResult(webIntent, webRequestCode)
    }
}
