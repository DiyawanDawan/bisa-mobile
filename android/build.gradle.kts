plugins {
    id("com.google.gms.google-services") version "4.4.4" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Prefer building from a path without spaces (e.g. D:\HACKATON\mobile_bisa-build).
// Custom buildDirectory redirects break AGP symbol tables on Flutter 3.44+.
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
