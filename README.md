# Flutter Plugin for Stipop UI SDK

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
dependencies {
  implementation 'com.github.stipop-development:stipop-android-sdk:0.3.2' 
}
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

#### Show Search (Sticker Search View)

**Search View** is where users can search for stickers with search tags like happy, sad, what!, and more and find stickers they can send on chat.

```dart
Stipop().showSearch();
```

#### Show Keyboard (Sticker Picker View on Keyboard)

**Sticker Picker View** provides in-depth sticker experience. Instead of instantaneous usage from the Search View, users can download and own stickers for a more intimate sticker sending experience.

```dart
Stipop().showKeyboard();
```

This method will hide 'Sticker Picker VIew', if it is currently showing.

```dart
Stipop().hideKeyboard();
```

#### Implement Sticker Send (Listening sticker, sticker pack selection event)

You might call this method at like 'initState()'.

```dart
Stipop(
    onStickerPackSelected: (spPackage) {
      // do something with sticker pack
    },
    onStickerSelected: (spSticker) {        
      // do something with sticker
    },
);
```



## Contact us

- Email us at tech-support@stipop.io if you need our help.