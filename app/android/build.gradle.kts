allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Версии, которые плагины задают диапазоном, закреплены: за списком версий
// диапазона Gradle ходит во все репозитории, мимо зеркала, и Maven Central
// отвечает раннерам 429 (CI-14, 28.11.2026 — posthog-android). Обновлять
// вместе с плагином: версия не ниже его диапазона.
val pinnedVersions =
    mapOf(
        // posthog_flutter 5.48.0: [3.70.0,4.0.0)
        "com.posthog:posthog-android" to "3.77.1",
    )
allprojects {
    configurations.configureEach {
        resolutionStrategy.eachDependency {
            pinnedVersions["${requested.group}:${requested.name}"]?.let {
                useVersion(it)
                because("CI-14: без списка версий из Maven Central")
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
