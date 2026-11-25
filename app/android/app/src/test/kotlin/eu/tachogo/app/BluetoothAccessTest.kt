package eu.tachogo.app

import android.Manifest
import android.app.Application
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config

/**
 * BT-08 (docs/testing.md): какие разрешения просит экран «Тахограф по
 * Bluetooth». Android 12+ — «Устройства поблизости», старше — геолокация:
 * без неё поиск Bluetooth LE ничего не находит. BT-13: сопряжение и тип
 * тахографа для журнала обмена.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class BluetoothAccessTest {
    private val app: Application = ApplicationProvider.getApplicationContext()

    @Test
    fun android12AndNewerAskForNearbyDevices() {
        assertArrayEquals(
            arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
            ),
            BluetoothAccess.permissions(31),
        )
    }

    @Test
    fun android11AndOlderAskForLocation() {
        assertArrayEquals(
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
            BluetoothAccess.permissions(30),
        )
    }

    @Test
    fun grantedOnlyWithBothPermissions() {
        assertFalse(BluetoothAccess.granted(app))
        shadowOf(app).grantPermissions(Manifest.permission.BLUETOOTH_SCAN)
        assertFalse(BluetoothAccess.granted(app))
        shadowOf(app).grantPermissions(Manifest.permission.BLUETOOTH_CONNECT)
        assertTrue(BluetoothAccess.granted(app))
    }

    @Test
    fun describesBondAndTypeOnlyWithPermissions() {
        val address = "00:60:37:01:D6:59"
        assertNull(BluetoothAccess.describe(app, address))
        shadowOf(app).grantPermissions(
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT,
        )
        assertEquals("bond none, type unknown", BluetoothAccess.describe(app, address))
        assertNull(BluetoothAccess.describe(app, "not an address"))
    }

    @Test
    fun foreignRequestCodeIsIgnored() {
        assertFalse(BluetoothAccess().onResult(app, BluetoothAccess.REQUEST_CODE + 1))
        assertTrue(BluetoothAccess().onResult(app, BluetoothAccess.REQUEST_CODE))
    }
}
