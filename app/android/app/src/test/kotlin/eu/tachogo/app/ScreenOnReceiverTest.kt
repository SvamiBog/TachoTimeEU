package eu.tachogo.app

import android.app.Application
import android.content.Intent
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config

/**
 * BG-10 (docs/testing.md): сервис автоопределения без wake lock —
 * при включении экрана задача сервиса получает `screen_on` и сразу
 * обновляет уведомление. Сама задача — в `app/test/background/`, что
 * манифест указывает [TachoGoApplication], — CI-06 (`app/tool/check_android_manifest.dart`).
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34], application = TachoGoApplication::class)
class ScreenOnReceiverTest {
    private val app: Application = ApplicationProvider.getApplicationContext()

    @Test
    fun `приложение слушает включение экрана`() {
        val registered = shadowOf(app).registeredReceivers.filter {
            it.broadcastReceiver is ScreenOnReceiver
        }
        assertEquals(1, registered.size)
        assertTrue(registered.single().intentFilter.hasAction(Intent.ACTION_SCREEN_ON))
    }

    @Test
    fun `экран включился — сообщение задаче сервиса`() {
        val sent = mutableListOf<Any?>()
        ScreenOnReceiver { sent += it }.onReceive(app, Intent(Intent.ACTION_SCREEN_ON))
        assertEquals(listOf<Any?>(ScreenOnReceiver.MESSAGE), sent)
    }

    @Test
    fun `другие события — ничего`() {
        val sent = mutableListOf<Any?>()
        val receiver = ScreenOnReceiver { sent += it }
        receiver.onReceive(app, Intent(Intent.ACTION_SCREEN_OFF))
        receiver.onReceive(app, null)
        assertTrue(sent.isEmpty())
    }
}
