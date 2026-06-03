# SEC-MOB-007: ProGuard / R8 rules untuk release build.
# Mempertahankan kelas yang dipakai Flutter & native plugins.

# Flutter engine + plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Awesome Notifications
-keep class me.carda.awesome_notifications.** { *; }
-keep class * extends me.carda.awesome_notifications.core.builders.NotificationBuilder { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Pusher
-keep class com.pusher.** { *; }

# Stripe / Xendit WebView communication (jika ada)
-keep class **.R$* { *; }

# JSON model serialization (json_serializable + freezed)
-keepattributes *Annotation*, InnerClasses
-dontwarn **
