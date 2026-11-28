package eu.tachogo.app

import android.app.Application
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * BT-18 (docs/testing.md): ошибка Bluetooth после обрыва связи не роняет
 * приложение, а начало стека настоящего падения доживает до следующего
 * поиска тахографа и попадает в журнал обмена.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class CrashGuardTest {
    private val app: Application = ApplicationProvider.getApplicationContext()

    @Test
    fun undeliverableBluetoothErrorsAreIgnored() {
        assertTrue(
            CrashGuard.ignorable(
                "io.reactivex.exceptions.UndeliverableException",
                "com.polidea.rxandroidble2.exceptions.BleDisconnectedException",
            ),
        )
        assertTrue(
            CrashGuard.ignorable(
                "com.polidea.rxandroidble2.exceptions.BleGattException",
                null,
            ),
        )
    }

    @Test
    fun otherErrorsStillCrash() {
        assertFalse(
            CrashGuard.ignorable(
                "io.reactivex.exceptions.UndeliverableException",
                "java.lang.IllegalStateException",
            ),
        )
        assertFalse(CrashGuard.ignorable("java.lang.NullPointerException", null))
        assertFalse(
            CrashGuard.ignorable("io.reactivex.exceptions.UndeliverableException", null),
        )
    }

    @Test
    fun recordedCrashIsReadOnce() {
        val error = IllegalStateException("Reply already submitted", RuntimeException("cause"))
        CrashGuard.record(app, "crash", error)
        val text = CrashGuard.takeLast(app)
        requireNotNull(text)
        assertTrue(text.startsWith("crash "))
        assertTrue(text.contains("IllegalStateException: Reply already submitted"))
        assertTrue(text.contains("Caused by: java.lang.RuntimeException: cause"))
        assertNull(CrashGuard.takeLast(app))
    }

    @Test
    fun descriptionKeepsOnlyTheTopOfEachStack() {
        val text = CrashGuard.describe("crash", deepError(50))
        val lines = text.lines()
        assertTrue(lines.size <= 30)
        assertEquals(6, lines.count { it.trimStart().startsWith("at ") })
    }

    private fun deepError(depth: Int): Throwable =
        if (depth == 0) IllegalStateException("deep") else deepError(depth - 1)
}
