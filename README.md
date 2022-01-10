# Flutter Plugin for Stipop UI SDK
![139039262-2fc7a0d2-d000-4848-b7be-eee2beede9f8](https://user-images.githubusercontent.com/42525347/143364965-8c6eb4cb-6108-48e7-810d-09a003f9ee4d.png)
Stipop SDK provides over 150,000 .png and .gif stickers that can be easily integrated into mobile app chats, comment sections, live streams, video calls, and other features. Bring fun to your mobile app with stickers loved by millions of users worldwide.



## Getting Started

Install plugin and follow below steps.


#### Android Integration

1. Sign up to <a href="https://dashboard.stipop.io/" target="_blank">Stipop Dashboard</a>
2. Create your application to get API Key.
3. Download **'Stipop.json'** file.
4. Move **Stipop.json** into the assets folder. ('android/app/src/main/assets')
5. Update gradle and add dependency.

```gradle
// at project level build.gradle
allprojects {
  repositories {
    maven { url 'https://jitpack.io' }
  }
}
// at app level build.gradle
defaultConfig {
  ..
  multiDexEnabled true // Maybe you need this options
}
dependencies {
  implementation 'com.github.stipop-development:stipop-android-sdk:0.5.0' 
}
```
6. Move at 'android/app/src/main/res/styles.xml' and change 'parent' to inherit 'Theme.MaterialComponents' because SDK UI uses MaterialComponents. Like below.

```xml
    <style name="LaunchTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>

    <style name="NormalTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
```
7. Move at 'android/app/src/main/{package}/MainActivity' and **change 'FlutterActivity' to 'FlutterFragmentActivity'** because SDK uses AndroidX UI components.

```kotlin
package com.stipop.stipop.stipop_plugin_example

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```

#### iOS Integration

1. Sign up to <a href="https://dashboard.stipop.io/" target="_blank">Stipop Dashboard</a>
2. Create your application to get API Key.
3. Download **'Stipop.plist'** file.
4. Open iOS module in Xcode
5. Drag & Drop **'Stipop.plist'** file into 'Runner' directory and import it.



**For more information to install or customize, Please read below docs.**

[Stipop Android Docs](https://docs.stipop.io/en/sdk/android/get-started/quick-start)

[Stipop iOS Docs](https://docs.stipop.io/en/sdk/ios/get-started/quick-start)





## Usage

#### Implement Sticker Send (Listening sticker, sticker pack selection event)

You might call this method at like 'initState()'.

```dart
  @override
  void initState() {
    super.initState();
    stipop = Stipop(
      'some_user_id',
      languageCode: 'en', 
      countryCode: 'US',
      onStickerPackSelected: (spPackage) {
        // Selected Sticker Pack passed here.
        setState(() {
          
        });
      },
      onStickerSelected: (sticker) {
        // Selected Sticker passed here.
        setState(() {
          
        });
      },
    );
  }
```
#### Show Search (Sticker Search View)

**Search View** is where users can search for stickers with search tags like happy, sad, what!, and more and find stickers they can send on chat.

```dart
stipop.showSearch();
```

#### Show Keyboard (Sticker Picker View on Keyboard)

**Sticker Picker View** provides in-depth sticker experience. Instead of instantaneous usage from the Search View, users can download and own stickers for a more intimate sticker sending experience.

```dart
stipop.showKeyboard();
```

This method will hide 'Sticker Picker VIew', if it is currently showing.

```dart
stipop.hideKeyboard();
```



## Contact us

- Email us at tech-support@stipop.io if you need our help.
