package eu.tachogo.tachogo

import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutostartSettings" -> result.success(openAutostartSettings())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Экран автозапуска или фоновой работы оболочки производителя: без
     * разрешения там MIUI, EMUI, ColorOS и One UI останавливают сервис
     * автоопределения. Если такого экрана нет — настройки приложения.
     */
    private fun openAutostartSettings(): Boolean {
        for (component in AUTOSTART_SCREENS) {
            try {
                startActivity(Intent().setComponent(component))
                return true
            } catch (e: Exception) {
                // Экрана нет в этой оболочке или он закрыт — пробуем следующий.
            }
        }
        startActivity(
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(Uri.fromParts("package", packageName, null)),
        )
        return false
    }

    private companion object {
        const val DEVICE_CHANNEL = "eu.tachogo/device"

        // Источник: dontkillmyapp.com и документация оболочек.
        val AUTOSTART_SCREENS = listOf(
            // Xiaomi, Redmi, POCO (MIUI, HyperOS)
            ComponentName(
                "com.miui.securitycenter",
                "com.miui.permcenter.autostart.AutoStartManagementActivity",
            ),
            // Huawei (EMUI)
            ComponentName(
                "com.huawei.systemmanager",
                "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity",
            ),
            ComponentName(
                "com.huawei.systemmanager",
                "com.huawei.systemmanager.optimize.process.ProtectActivity",
            ),
            // Honor (MagicOS)
            ComponentName(
                "com.hihonor.systemmanager",
                "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity",
            ),
            // Oppo, Realme, OnePlus (ColorOS)
            ComponentName(
                "com.coloros.safecenter",
                "com.coloros.safecenter.permission.startup.StartupAppListActivity",
            ),
            ComponentName(
                "com.oplus.safecenter",
                "com.oplus.safecenter.permission.startup.StartupAppListActivity",
            ),
            // Vivo
            ComponentName(
                "com.vivo.permissionmanager",
                "com.vivo.permissionmanager.activity.BgStartUpManagerActivity",
            ),
            // Samsung (One UI): «Батарея» → ограничения фоновой работы
            ComponentName(
                "com.samsung.android.lool",
                "com.samsung.android.sm.battery.ui.BatteryActivity",
            ),
        )
    }
}
