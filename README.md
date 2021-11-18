# stipop

Flutter plugin for StipopSDK

## Getting Started

Check out the example directory for a sample app.

#### Android Integration

[Stipop Android Docs](https://docs.stipop.io/en/sdk/android/get-started/quick-start)

#### iOS Integration

[Stipop iOS Docs](https://docs.stipop.io/en/sdk/ios/get-started/quick-start)

## Usage

#### Show Search

You can simply modal our SDK. This will show you the search view.

```dart
Stipop().showSearch();
```

#### Show Keyboard

You can simply modal our SDK. This will show you the keyboard view.

```dart
Stipop().showKeyboard();
```

#### Implement Sticker Send

```dart
Stipop(
    canDownlaod: (spPackage) {        
    },
    onStickerSelected: (sticker) {        
    },
);
```