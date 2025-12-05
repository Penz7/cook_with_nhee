import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Base64

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.penz.cook_with_nhee"
    compileSdk = 36
    ndkVersion = "29.0.13113456 rc1"

    val dartEnvironmentVariables = mutableMapOf(
        "APP_NAME" to "Cook with Nhee",
        "APP_SUFFIX" to null as String?
    )

    if (project.hasProperty("dart-defines")) {
        val dartDefines = project.property("dart-defines") as String
        val definesMap = dartDefines.split(",").associate {
            val decoded = String(Base64.getDecoder().decode(it))
            val pair = decoded.split("=")
            pair[0] to pair.getOrNull(1)
        }
        dartEnvironmentVariables.putAll(definesMap)
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.penz.cook_with_nhee"
        minSdk = 24
        targetSdk = 36
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        for (entry in dartEnvironmentVariables.entries) {
            val key = entry.key
            val value = entry.value
            value?.let {
                manifestPlaceholders[key] = it
                resValue("string", key, it)
            }
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "app"

    productFlavors {
        create("production") {
            dimension = "app"
        }
        create("develop") {
            dimension = "app"
            applicationId = "com.penz.cook_with_nhee"
            versionNameSuffix = ".dev"
        }
    }
}

fun dependencies() {}

flutter {
    source = "../.."
}
