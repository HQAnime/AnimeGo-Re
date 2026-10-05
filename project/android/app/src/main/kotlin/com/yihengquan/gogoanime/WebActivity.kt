package com.yihengquan.gogoanime

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat

class WebActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_webview)

        // Match the app's light/dark theme in the status bar icons.
        val dark = intent.getBooleanExtra("dark", false)
        WindowCompat.getInsetsController(window, window.decorView)
            .isAppearanceLightStatusBars = !dark

        // Fall back to the default site so the bypass never starts empty.
        val link = intent.getStringExtra("link")?.takeIf { it.isNotBlank() }
            ?: "https://gogoanime3.co/"

        // Clear cookies to get a fresh cf_clearance.
        CookieManager.getInstance().removeAllCookies {
            println("Cookies are removed, $it")
        }

        val webView = findViewById<WebView>(R.id.webView)
        webView.settings.javaScriptEnabled = true
        // Cloudflare's challenge (turnstile) needs DOM storage.
        webView.settings.domStorageEnabled = true
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            webView.settings.forceDark =
                if (dark) WebSettings.FORCE_DARK_ON else WebSettings.FORCE_DARK_OFF
        }
        webView.clearCache(false)
        webView.webViewClient = WebClient(this)
        webView.loadUrl(link)
    }
}

class WebClient(private val activity: AppCompatActivity) : WebViewClient() {

    // A Cloudflare challenge page also fires onPageFinished, so keep polling
    // until the real cf_clearance cookie shows up or the challenge markers are
    // gone. Give up after maxWaitSec.
    private val maxWaitSec = 60
    private var finished = false

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)
        waitForCookie(view, 0)
    }

    @Suppress("DEPRECATION")
    override fun onReceivedError(
        view: WebView?, errorCode: Int, description: String?, failingUrl: String?
    ) {
        super.onReceivedError(view, errorCode, description, failingUrl)
        // Keep the activity open so the challenge can run.
        println("webview error: $errorCode $description ($failingUrl)")
    }

    private fun waitForCookie(view: WebView?, attempt: Int) {
        if (view == null || finished) return
        val url = view.url
        // cf_clearance is the definitive "challenge passed" signal.
        val cookie = CookieManager.getInstance().getCookie(url)
        if (cookie?.contains("cf_clearance") == true) {
            finishWithCookie(view, cookie)
            return
        }
        if (attempt >= maxWaitSec) {
            finishWithCookie(view, cookie)
            return
        }
        view.evaluateJavascript(
            """(function() {
                return document.getElementsByTagName('html')[0].innerHTML;
            })()""".trimMargin()
        ) { html ->
            if (finished) return@evaluateJavascript
            val stillChecking = html == null ||
                html.contains("Checking your browser before accessing") ||
                html.contains("Just a moment") ||
                html.contains("challenge-platform") ||
                html.contains("cf-chl") ||
                html.contains("cf-browser-verification") ||
                html.contains("Verify you are human") ||
                html.contains("Turnstile")
            if (!stillChecking) {
                finishWithCookie(view, cookie)
            } else {
                view.postDelayed({ waitForCookie(view, attempt + 1) }, 1000)
            }
        }
    }

    private fun finishWithCookie(view: WebView, cookie: String?) {
        if (finished) return
        finished = true
        val userAgent = view.settings.userAgentString
        view.stopLoading()
        view.onPause()
        view.removeAllViews()

        val data = Intent().apply {
            putExtra("cookie", cookie)
            putExtra("agent", userAgent)
        }
        activity.setResult(1111, data)
        activity.finish()
        println("cookie fixed")
    }
}
