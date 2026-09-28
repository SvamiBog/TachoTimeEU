package eu.tachogo.tachogo

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutostartSettings" -> result.success(AutostartSettings(this).open())
                    "deviceInfo" -> result.success(deviceInfo())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Телефон для отчёта о проблеме в бете: от производителя и версии
     * Android зависит, доживёт ли сервис и придут ли уведомления.
     */
    private fun deviceInfo(): Map<String, Any> = mapOf(
        "manufacturer" to Build.MANUFACTURER,
        "model" to Build.MODEL,
        "release" to Build.VERSION.RELEASE,
        "sdk" to Build.VERSION.SDK_INT,
    )

    private companion object {
        const val DEVICE_CHANNEL = "eu.tachogo/device"
    }
}
