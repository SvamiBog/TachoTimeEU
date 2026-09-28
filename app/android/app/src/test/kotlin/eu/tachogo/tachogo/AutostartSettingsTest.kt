package eu.tachogo.tachogo

import android.app.Application
import android.content.ComponentName
import android.content.IntentFilter
import android.provider.Settings
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config

/**
 * BG-09 (docs/testing.md): экран автозапуска оболочки. Телефон «без
 * оболочки» — пакетный менеджер Robolectric, в котором есть только
 * настройки приложения; экраны оболочек тест добавляет сам. Экран, которого
 * нет, не открывается (checkActivities) — как ActivityNotFoundException на
 * телефоне.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class AutostartSettingsTest {
    private val app: Application = ApplicationProvider.getApplicationContext()
    private val packages = shadowOf(app.packageManager)

    @Before
    fun setUp() {
        shadowOf(app).checkActivities(true)
        val settings = ComponentName(
            "com.android.settings",
            "com.android.settings.applications.InstalledAppDetails",
        )
        packages.addActivityIfNotPresent(settings)
        packages.addIntentFilterForActivity(
            settings,
            IntentFilter(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                addDataScheme("package")
            },
        )
    }

    @Test
    fun `без экранов оболочки — настройки приложения и false`() {
        assertFalse(AutostartSettings(app).open())
        val started = shadowOf(app).nextStartedActivity
        assertEquals(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, started.action)
        assertEquals("package:${app.packageName}", started.dataString)
        assertNull(shadowOf(app).nextStartedActivity)
    }

    @Test
    fun `Xiaomi — экран автозапуска MIUI и true`() {
        val miui = ComponentName(
            "com.miui.securitycenter",
            "com.miui.permcenter.autostart.AutoStartManagementActivity",
        )
        packages.addActivityIfNotPresent(miui)
        assertTrue(AutostartSettings(app).open())
        assertEquals(miui, shadowOf(app).nextStartedActivity.component)
        assertNull(shadowOf(app).nextStartedActivity)
    }

    @Test
    fun `экраны перебираются по порядку — открывается первый, который есть`() {
        // Старая EMUI: первого экрана Huawei нет, второй есть; Samsung ниже
        val protect = AutostartSettings.SCREENS[2]
        val samsung = AutostartSettings.SCREENS.last()
        packages.addActivityIfNotPresent(samsung)
        packages.addActivityIfNotPresent(protect)
        assertTrue(AutostartSettings(app).open())
        assertEquals(protect, shadowOf(app).nextStartedActivity.component)
    }

    @Test
    fun `каждый экран оболочки открывается, если он один`() {
        for (screen in AutostartSettings.SCREENS) {
            packages.addActivityIfNotPresent(screen)
            assertTrue(screen.flattenToString(), AutostartSettings(app).open())
            assertEquals(screen, shadowOf(app).nextStartedActivity.component)
            packages.removeActivity(screen)
        }
    }

    @Test
    fun `из приложения, а не из экрана, — в новой задаче`() {
        AutostartSettings(app).open()
        val flags = shadowOf(app).nextStartedActivity.flags
        assertTrue(flags and android.content.Intent.FLAG_ACTIVITY_NEW_TASK != 0)
    }
}
