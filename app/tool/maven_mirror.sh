#!/usr/bin/env bash
# Зеркало Maven Central у Google — первым репозиторием Gradle на раннере CI
# (CI-14, docs/testing.md). 25.11.2026 Maven Central полдня отвечал адресам
# раннеров GitHub 429 «слишком много запросов» — сначала на jar-файлы, потом
# и на POM, — и повтор с паузами до 4 мин (tool/gradle_deps.sh,
# tool/robolectric_tests.sh) не помогал: сборка Android падала на тестах
# Robolectric, тестовая APK не загружалась.
#
# Скрипт кладёт init-скрипт в ~/.gradle/init.d: Gradle применяет его ко всем
# сборкам на машине — приложению, плагинам Flutter и их buildscript, — и
# ставит зеркало перед репозиториями проекта; сборке, где проекту свои
# репозитории запрещены (FAIL_ON_PROJECT_REPOS у сборки плагинов Flutter),
# — в репозитории настроек. Чего на зеркале нет, Gradle
# ищет дальше по списку проекта (google(), mavenCentral()). Robolectric
# качает образ Android мимо Gradle — ему зеркало передаётся свойством
# robolectric.dependency.repo.url. Проект и локальные сборки не меняются.
#
#   tool/maven_mirror.sh

set -euo pipefail

init_dir="${GRADLE_USER_HOME:-$HOME/.gradle}/init.d"
mkdir -p "$init_dir"
cat > "$init_dir/maven-central-mirror.gradle" <<'GRADLE'
// Зеркало Maven Central у Google — первым (app/tool/maven_mirror.sh, CI-14)
def mirror = 'https://maven-central.storage-download.googleapis.com/maven2/'
def addMirror = { RepositoryHandler repos ->
    if (repos.findByName('MavenCentralMirror') == null) {
        def repo = repos.maven {
            name = 'MavenCentralMirror'
            url = mirror
        }
        repos.remove(repo)
        repos.addFirst(repo)
    }
}
// Сборка, где проекту свои репозитории нельзя (сборка плагинов Flutter:
// FAIL_ON_PROJECT_REPOS), берёт зеркало из настроек
def projectRepos = true
beforeSettings { settings ->
    addMirror(settings.dependencyResolutionManagement.repositories)
    // Плагины из блока plugins {} файла настроек ищутся во время его
    // выполнения — зеркало нужно до него (26.11.2026 плагин Kotlin не
    // скачался: Maven Central и Plugin Portal отказали)
    addMirror(settings.pluginManagement.repositories)
}
settingsEvaluated { settings ->
    projectRepos = settings.dependencyResolutionManagement.repositoriesMode
        .get() == RepositoriesMode.PREFER_PROJECT
    // Своих репозиториев плагинов у сборки нет — без зеркала она брала бы
    // плагины с Plugin Portal: он нужен и теперь, после зеркала
    def plugins = settings.pluginManagement.repositories
    if (plugins.size() == 1) plugins.gradlePluginPortal()
    addMirror(plugins)
}
allprojects {
    if (projectRepos) {
        addMirror(buildscript.repositories)
        addMirror(repositories)
    }
    tasks.withType(Test).configureEach {
        systemProperty 'robolectric.dependency.repo.url', mirror
    }
}
GRADLE
echo "Зеркало Maven Central: $init_dir/maven-central-mirror.gradle"
