# Add project-specific ProGuard rules here.
# You can control the set of applied rules by using the
# proguardFiles() method in your module-level build.gradle.kts file.

# Flutter uses code shrinking and obfuscation for release builds.
# Keep the default Android support libraries.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class com.android.** { *; }

# Keep the generated plugin registrant.
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
