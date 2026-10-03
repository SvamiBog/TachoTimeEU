import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Ключ подписи релиза: android/key.properties (не в git, в CI собирается из секретов).
// Без файла релиз подписывается debug-ключом — годится только для локальной проверки.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

android {
    // Идентификатор закреплён за приложением в Google Play с первой загрузкой —
    // не менять (вопрос 14 PRD, решение 2026-09-30).
    namespace = "eu.tachogo.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications: java.time на старых Android.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "eu.tachogo.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Тестовые APK из CI — постоянным debug-ключом (секрет
        // ANDROID_DEBUG_KEYSTORE_BASE64), чтобы каждая ставилась поверх
        // прошлой. Путь задан явно: место ключа по умолчанию (~/.android)
        // зависит от переменных окружения, и Gradle молча создаёт там свой.
        System.getenv("TACHOGO_DEBUG_KEYSTORE")?.let { path ->
            getByName("debug") {
                storeFile = file(path)
                storePassword = "android"
                keyAlias = "androiddebugkey"
                keyPassword = "android"
            }
        }
        if (keystoreProperties.isNotEmpty()) {
            fun required(key: String): String =
                keystoreProperties.getProperty(key)
                    ?: throw GradleException("android/key.properties: не задан $key")
            create("release") {
                keyAlias = required("keyAlias")
                keyPassword = required("keyPassword")
                storeFile = file(required("storeFile"))
                storePassword = required("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug").also {
                    logger.warn(
                        "android/key.properties не найден: release подписан debug-ключом, " +
                            "в Google Play такую сборку загрузить нельзя",
                    )
                }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Тесты нативной части на JVM (BG-09): ./gradlew :app:testDebugUnitTest
    testImplementation("junit:junit:4.13.2")
    testImplementation("androidx.test:core:1.6.1")
    testImplementation("org.robolectric:robolectric:4.16")
}
