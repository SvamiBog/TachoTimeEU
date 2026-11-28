package eu.tachogo.app

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.plugin.common.MethodChannel

/**
 * Разрешения Bluetooth для экрана «Тахограф по Bluetooth» (бета).
 *
 * Android 12+ — «Устройства поблизости» (BLUETOOTH_SCAN с neverForLocation и
 * BLUETOOTH_CONNECT), Android 11 и старше — геолокация: без неё поиск
 * Bluetooth LE ничего не находит. Запрос — один за раз: результат приходит
 * в [onResult] из `MainActivity.onRequestPermissionsResult`.
 */
class BluetoothAccess {
    private var pending: MethodChannel.Result? = null

    fun request(activity: Activity, result: MethodChannel.Result) {
        if (granted(activity)) {
            result.success(true)
            return
        }
        // Прошлый запрос без ответа — считаем отказом
        pending?.success(false)
        pending = result
        activity.requestPermissions(permissions(), REQUEST_CODE)
    }

    /** Ответ системного диалога; false — запрос не наш. */
    fun onResult(context: Context, requestCode: Int): Boolean {
        if (requestCode != REQUEST_CODE) return false
        pending?.success(granted(context))
        pending = null
        return true
    }

    companion object {
        const val REQUEST_CODE = 4101

        fun permissions(sdk: Int = Build.VERSION.SDK_INT): Array<String> =
            if (sdk >= Build.VERSION_CODES.S) {
                arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT,
                )
            } else {
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
            }

        fun granted(context: Context): Boolean = permissions().all {
            context.checkSelfPermission(it) == PackageManager.PERMISSION_GRANTED
        }

        /**
         * Сопряжение и тип устройства для журнала обмена с тахографом:
         * «bond bonded, type le». По ним видно, сопряжён ли телефон с
         * тахографом и по Bluetooth LE ли. Без разрешений или с неверным
         * адресом — null.
         */
        @SuppressLint("MissingPermission") // разрешения проверены выше
        fun describe(context: Context, address: String): String? {
            if (!granted(context)) return null
            val adapter = context.getSystemService(BluetoothManager::class.java)
                ?.adapter ?: return null
            return try {
                val device = adapter.getRemoteDevice(address)
                val bond = when (device.bondState) {
                    BluetoothDevice.BOND_BONDED -> "bonded"
                    BluetoothDevice.BOND_BONDING -> "bonding"
                    else -> "none"
                }
                val type = when (device.type) {
                    BluetoothDevice.DEVICE_TYPE_LE -> "le"
                    BluetoothDevice.DEVICE_TYPE_CLASSIC -> "classic"
                    BluetoothDevice.DEVICE_TYPE_DUAL -> "dual"
                    else -> "unknown"
                }
                "bond $bond, type $type"
            } catch (e: IllegalArgumentException) {
                null
            } catch (e: SecurityException) {
                null
            }
        }
    }
}
