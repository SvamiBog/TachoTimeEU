package eu.tachogo.app

import android.app.Application

/**
 * Процесс приложения: в нём работают и экраны, и сервис автоопределения.
 * Приёмник включения экрана живёт, пока жив процесс, — см. [ScreenOnReceiver].
 */
class TachoGoApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        ScreenOnReceiver.register(this)
    }
}
