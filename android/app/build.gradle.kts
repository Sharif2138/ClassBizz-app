// App-level build.gradle.kts

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase Google Services plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin
}

android {
    namespace = "com.example.classbizz_app"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.classbizz_app"
        minSdk = 19
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.2.2")) // Firebase BOM
    implementation("com.google.firebase:firebase-auth-ktx") // Firebase Auth
}

// Flutter source
flutter {
    source = "../.."
}
