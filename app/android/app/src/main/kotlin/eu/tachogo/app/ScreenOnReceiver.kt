package eu.tachogo.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import com.pravera.flutter_foreground_task.service.ForegroundService

/**
 * Экран включился — задача сервиса автоопределения сразу обновляет
 * уведомление. Сервис не держит wake lock (метрика Android vitals
 * «избыточные частичные wake lock»): на стоянке с выключенным экраном его
 * обновление раз в минуту засыпает вместе с телефоном, и без этого сигнала
 * после включения экрана уведомление до минуты показывало бы остатки на
 * момент, когда телефон уснул.
 *
 * SCREEN_ON система доставляет только приёмникам, зарегистрированным из
 * кода, — регистрирует [TachoGoApplication]. Сервис работает в том же
 * процессе; если он не запущен, сообщение никуда не уходит.
 */
class ScreenOnReceiver(
    private val send: (Any?) -> Unit = { ForegroundService.sendData(it) },
) : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_SCREEN_ON) send(MESSAGE)
    }

    companion object {
        /** Как `screenOnMessage` в `lib/background/tracking_task.dart`. */
        const val MESSAGE = "screen_on"

        fun register(context: Context, receiver: ScreenOnReceiver = ScreenOnReceiver()) {
            val filter = IntentFilter(Intent.ACTION_SCREEN_ON)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Системные рассылки приходят и приёмнику, закрытому для
                // других приложений.
                context.registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                context.registerReceiver(receiver, filter)
            }
        }
    }
}
