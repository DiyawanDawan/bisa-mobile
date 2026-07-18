import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// SEC-MOB-007: load release keystore properties dari `android/key.properties`.
// File ini di-gitignore. Jika tidak ada (CI tanpa keystore), fallback ke debug
// signing — JANGAN distribusikan APK debug-signed ke Play Store / production.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKeystore = keystorePropertiesFile.exists()
if (hasReleaseKeystore) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.apps.mobile_bisa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.apps.mobile_bisa"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        // Real devices only — skip x86/x86_64 to avoid Windows strip file-lock races.
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a")
        }
    }

    packaging {
        jniLibs {
            // Avoid :app:stripReleaseDebugSymbols file locks on Windows.
            keepDebugSymbols += listOf("**/*.so")
        }
    }

    // SEC-MOB-007: dedicated release signing config (loaded dari key.properties).
    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // SEC-MOB-007: pakai keystore release jika tersedia, fallback debug
            // hanya untuk lokal `flutter run --release` saat development.
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Path project mengandung spasi ("Mobile Apps") — skip native debug
            // symbol extract yang sering gagal di Windows (NoSuchFileException).
            ndk {
                debugSymbolLevel = "NONE"
            }

            // Sementara nonaktifkan R8: path "Mobile Apps" (spasi) sering
            // memicu NoSuchFileException di minifyReleaseWithR8 di Windows.
            isMinifyEnabled = false
            isShrinkResources = false
            // isMinifyEnabled = true
            // isShrinkResources = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro",
            // )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))
    implementation("com.google.firebase:firebase-analytics")
}
