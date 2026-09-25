# Google ML Kit and all its internal modules
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Firebase Components used by ML Kit for Dependency Injection
-keep class com.google.firebase.components.** { *; }
-dontwarn com.google.firebase.components.**

# Google Play Services common components
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.common.**