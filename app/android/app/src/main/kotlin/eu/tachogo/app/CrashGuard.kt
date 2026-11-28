package eu.tachogo.app

import android.content.Context
import android.util.Log
import io.reactivex.plugins.RxJavaPlugins
import java.io.File
import java.time.Instant

/**
 * Падения нативной части — для журнала обмена сборки разработчика (BT-18).
 *
 * flutter_reactive_ble построен на RxAndroidBle и RxJava 2. Ошибку Bluetooth,
 * пришедшую после отмены подписки (связь с тахографом закрыли или она
 * оборвалась), RxJava некому доставить, и по умолчанию она роняет
 * приложение (UndeliverableException; RxAndroidBle советует свой обработчик).
 * Такие ошибки пишем в лог и не падаем; остальные падения, как и раньше,
 * роняют приложение, но сначала их начало сохраняется в файл, и при
 * следующем поиске тахографа оно попадает в журнал обмена.
 */
object CrashGuard {
    private const val TAG = "TachoGo"
    private const val FILE = "last_native_crash.txt"

    /** Строк «at …» под каждым исключением и всего строк в файле. */
    private const val FRAMES = 6
    private const val MAX_LINES = 30

    private const val UNDELIVERABLE = "io.reactivex.exceptions.UndeliverableException"
    private const val BLE_EXCEPTIONS = "com.polidea.rxandroidble2.exceptions."

    @Volatile
    private var installed = false

    fun install(context: Context) {
        if (installed) return
        installed = true
        val app = context.applicationContext
        val previous = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler { thread, error ->
            record(app, "crash", error)
            previous?.uncaughtException(thread, error)
        }
        RxJavaPlugins.setErrorHandler { error ->
            if (ignorable(error.javaClass.name, error.cause?.javaClass?.name)) {
                Log.w(TAG, "undeliverable Bluetooth error", error)
                record(app, "handled", error)
                return@setErrorHandler
            }
            // Как у RxJava по умолчанию: необработанная ошибка роняет поток
            val thread = Thread.currentThread()
            thread.uncaughtExceptionHandler?.uncaughtException(thread, error)
        }
    }

    /** Ошибка RxAndroidBle, которую некому доставить, — не повод падать. */
    fun ignorable(errorClass: String, causeClass: String?): Boolean {
        val ble = if (errorClass == UNDELIVERABLE) causeClass else errorClass
        return ble?.startsWith(BLE_EXCEPTIONS) == true
    }

    /** Сохранить начало стека: [kind] — «crash» или «handled». */
    fun record(context: Context, kind: String, error: Throwable) {
        try {
            File(context.filesDir, FILE).writeText(describe(kind, error))
        } catch (e: Exception) {
            Log.w(TAG, "crash record failed", e)
        }
    }

    /** Сохранённое падение; прочитанное удаляется. */
    fun takeLast(context: Context): String? {
        val file = File(context.filesDir, FILE)
        if (!file.exists()) return null
        return try {
            file.readText().also { file.delete() }
        } catch (e: Exception) {
            null
        }
    }

    /** Исключение и причины, под каждым — первые [FRAMES] строк стека. */
    fun describe(kind: String, error: Throwable): String {
        val lines = mutableListOf("$kind ${Instant.now()}")
        var frames = 0
        for (line in Log.getStackTraceString(error).lines()) {
            if (line.isBlank()) continue
            val frame = line.trimStart().startsWith("at ")
            if (frame && frames++ >= FRAMES) continue
            if (!frame) frames = 0
            lines += line.trimEnd()
            if (lines.size >= MAX_LINES) break
        }
        return lines.joinToString("\n")
    }
}
