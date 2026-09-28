package eu.tachogo.tachogo

import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

/**
 * Экран автозапуска или фоновой работы оболочки производителя: без
 * разрешения там MIUI, EMUI, ColorOS и One UI останавливают сервис
 * автоопределения и будильники уведомлений. Экраны перебираются по порядку;
 * если ни одного нет — открываются настройки приложения.
 */
class AutostartSettings(private val context: Context) {
    /** true — открылся экран оболочки, false — настройки приложения. */
    fun open(): Boolean {
        for (component in SCREENS) {
            try {
                start(Intent().setComponent(component))
                return true
            } catch (e: Exception) {
                // Экрана нет в этой оболочке или он закрыт — пробуем следующий.
            }
        }
        start(
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(Uri.fromParts("package", context.packageName, null)),
        )
        return false
    }

    private fun start(intent: Intent) {
        if (context !is Activity) intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    companion object {
        // Источник: dontkillmyapp.com и документация оболочек.
        val SCREENS = listOf(
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
