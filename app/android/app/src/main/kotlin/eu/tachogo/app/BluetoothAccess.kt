package eu.tachogo.app

import android.Manifest
import android.app.Activity
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
    }
}
