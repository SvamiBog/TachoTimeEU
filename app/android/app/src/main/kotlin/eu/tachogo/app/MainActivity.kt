package eu.tachogo.app

import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val bluetoothAccess = BluetoothAccess()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutostartSettings" -> result.success(AutostartSettings(this).open())
                    "deviceInfo" -> result.success(deviceInfo())
                    "bluetoothPermissions" -> result.success(BluetoothAccess.granted(this))
                    "requestBluetoothPermissions" -> bluetoothAccess.request(this, result)
                    "openBluetoothSettings" -> result.success(openBluetoothSettings())
                    "bluetoothDevice" -> result.success(
                        BluetoothAccess.describe(this, call.arguments as? String ?: ""),
                    )
                    "lastNativeCrash" -> result.success(CrashGuard.takeLast(this))
                    else -> result.notImplemented()
                }
            }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        bluetoothAccess.onResult(this, requestCode)
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

    /** Настройки Bluetooth телефона: водитель включает его сам. */
    private fun openBluetoothSettings(): Boolean = try {
        startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
        true
    } catch (e: android.content.ActivityNotFoundException) {
        false
    }

    private companion object {
        const val DEVICE_CHANNEL = "eu.tachogo/device"
    }
}
