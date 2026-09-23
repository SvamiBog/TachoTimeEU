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
    // Идентификатор временный: финальное название приложения ещё не выбрано.
    namespace = "eu.tachotime.tachotime"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "eu.tachotime.tachotime"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
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
