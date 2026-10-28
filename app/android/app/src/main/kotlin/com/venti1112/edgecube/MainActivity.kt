package com.venti1112.edgecube

import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import com.venti1112.edgecube.localservice.LocalServiceChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestLocalNetworkPermission()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        LocalServiceChannel.register(
            flutterEngine.dartExecutor.binaryMessenger,
            applicationContext,
        )
    }

    /**
     * Android 17 起，targetSdk 37 的应用访问局域网要运行时授予 ACCESS_LOCAL_NETWORK，
     * 不申请就一直是被拒状态（连局域网 daemon、UPnP 发现都会失败）。
     * 旧系统没有这个权限，直接跳过。
     */
    private fun requestLocalNetworkPermission() {
        if (Build.VERSION.SDK_INT < FIRST_LOCAL_NETWORK_SDK) return
        if (checkSelfPermission(LOCAL_NETWORK_PERMISSION) == PackageManager.PERMISSION_GRANTED) {
            return
        }
        requestPermissions(arrayOf(LOCAL_NETWORK_PERMISSION), REQUEST_LOCAL_NETWORK)
    }

    private companion object {
        /** Android 17 的首个 API 级别 */
        const val FIRST_LOCAL_NETWORK_SDK = 37
        const val LOCAL_NETWORK_PERMISSION = "android.permission.ACCESS_LOCAL_NETWORK"
        const val REQUEST_LOCAL_NETWORK = 1001
    }
}
