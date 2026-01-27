plugins {
    id("org.jetbrains.kotlin.android") version "2.1.20" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.0.21" apply false
}
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Force all Flutter plugin subprojects to use compileSdk 36.
// Some plugins (e.g., flutter_compass_v2) are compiled against an older SDK (android-33),
// but their AndroidX dependencies require compileSdk 34+. This override ensures compatibility.
// See: https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/267
gradle.beforeProject {
    if (project.name != "app" && project.name != rootProject.name) {
        project.afterEvaluate {
            val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            android?.compileSdkVersion(36)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
