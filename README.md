# The Quran

A beautiful, minimal Flutter app for reading the Holy Quran. It includes all 114 Surahs and 604 pages of the authentic Madani Mushaf, with elegant bookmarks, a smart "Continue Reading" tracker, and a smooth, distraction-free reading experience on Android, iOS, and Web.

## Features

The app offers the complete Quran with authentic page numbering, a premium teal-themed design, smart bookmarks that persist across sessions, an automatic "Continue Reading" tracker that remembers your last page, a fast Surah search by name or Arabic or page number, pinch-to-zoom on every page, pre-cached pages for smooth swiping, a clean light theme built for long reading, and multi-platform support for Android, iOS, and Web with Device Preview integration.

## Getting Started

You need the Flutter SDK version 3.0.0 or higher, the Dart SDK bundled with Flutter, Android Studio or VS Code with the Flutter extension, and an emulator, physical device, or Chrome browser for testing.

To install, clone the repository and enter the folder, then run `flutter pub get` to install dependencies. You can then run the app with `flutter run` on a connected device, `flutter run -d chrome` for the web, or `flutter devices` followed by `flutter run -d <device_id>` to target a specific device. To build a release APK, run `flutter build apk --release`, and the output will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## Project Structure

The project contains an `android` folder for Android native configuration, an `ios` folder for iOS native configuration, an `assets` folder holding the banner image, logo, and all 604 Quran page images inside `assets/quranpages/`, a `lib` folder containing `main.dart` for the app entry and theme and screens, `bookmark_service.dart` for persistent bookmark and last-read storage, and `quran_data.dart` for all 114 Surahs with their metadata, plus the `pubspec.yaml` file for dependencies and asset registration, and this `README.md`.

## Dependencies

The app uses `device_preview` for testing the UI on different device frames, and `shared_preferences` for persistent bookmark and last-read storage.

## Design Language

The app follows a minimal, classic, and premium aesthetic inspired by well-designed reading apps. The primary color is teal `#008080`, with dark accent `#00595A`, faint tint `#E0F0F0`, background `#FAFAFA`, white surfaces, primary text `#1A1A1A`, and muted text `#6B6B6B`. Typography uses the system default with tightened letter-spacing and weighted hierarchy, corners are sharp or gently rounded between 10 and 16 pixels, motion uses subtle consistent durations with easeOutCubic, and icons come from the Material Rounded set for a soft modern feel.

## Usage Guide

On the Home Screen, you will find a branded hero banner with tagline, live stats showing Surah count, page count, and saved bookmarks, a "Continue Reading" card to resume from your last page, and a Surah list where only the list scrolls while the top area stays fixed.

On the Reading Screen, swipe left or right to navigate between pages, pinch to zoom in or out up to four times, tap the page to toggle the bottom floating bar, tap Save to bookmark the current page, and tap the book icon in the top-right to open the Surah picker.

On the Bookmarks Screen, tap any bookmark to jump to that page, tap the trash icon on any row to remove a single bookmark, and tap the sweep icon in the top-right to clear all bookmarks with a confirmation dialog.

## Adding Quran Page Images

The app expects 604 PNG files inside `assets/quranpages/`, named exactly `page001.png`, `page002.png`, and so on up to `page604.png`, using three-digit padding with leading zeros. If your images use a different naming scheme, edit the `pagePath` function in `lib/quran_data.dart` to match. Recommended image specifications are PNG-8, WebP, or JPEG format, roughly 1080 pixels wide, between 200 and 500 kilobytes per page, resulting in a total app size of around 150 to 300 megabytes. You can reduce size by about 60 percent by converting images to WebP.

## How Bookmarks Work

Bookmarks are stored locally using `shared_preferences` and persist across app restarts. You add a bookmark by tapping Save while reading, remove it by tapping Save again or swiping from the Bookmarks screen, and the last-read page is automatically saved on every page change. An in-memory cache provides instant reads without disk input and output. Two storage keys are used: `quran_bookmarks` for the list of bookmarked pages, and `quran_last_read` for the last-read page number.

## Testing Checklist

Before releasing, verify that bookmarking a page, killing the app, and reopening it still shows the bookmark. Swipe through ten pages and confirm the last-read updates correctly. Open a Surah from the picker and confirm it jumps to the correct page. Search for "Yusuf" and "يوسف" in the picker and confirm both find the Surah. Clear all bookmarks and confirm the dialog appears. Pinch to zoom and release to reset. Rotate the device and confirm the layout stays intact. Toggle the device preview frames if you are using device_preview.

## Building for Production

For an Android APK, run `flutter clean`, then `flutter pub get`, then `flutter build apk --release`. For an Android App Bundle for the Play Store, run `flutter build appbundle --release`. For iOS, run `flutter build ios --release`, which requires macOS, Xcode, and an Apple Developer account. For Web, run `flutter build web --release`. Before shipping, disable device_preview by changing the enabled flag in `lib/main.dart` to use `!kReleaseMode` instead of `true`.

## Troubleshooting

If you see the error "No file or variants found for asset", make sure the file exists at the exact path or remove the entry from `pubspec.yaml`. If you see "Unable to load asset" for a Quran page, check the file naming uses three digits, the `.png` extension, and lowercase letters. If pages appear blank, verify the images are not corrupted by testing a few files first. If you get a "MissingPluginException" after adding a package, run `flutter clean` and `flutter pub get` and rebuild. If the first launch feels slow, note that pre-caching runs in the background and subsequent launches will be fast. After any change to `pubspec.yaml`, always run `flutter clean`, then `flutter pub get`, then `flutter run`.

## Contributing

Contributions are welcome. Fork the repository, create a feature branch, commit your changes, push to the branch, and open a pull request. Please follow the existing code style and design language.

## License

This project is licensed under the MIT License. See the LICENSE file for details. The Quran text and page images are the sacred word of Allah and are not covered by this license. Please ensure any images you add comply with local copyright and religious guidelines.

## Acknowledgements

Thanks to the Holy Quran, the source of all guidance. Thanks to the Flutter team for an incredible cross-platform framework. And thanks to the Ummah developers who build tools to make the Quran more accessible.

## Contact

For questions, suggestions, or bug reports, please open an issue on GitHub.

"Indeed, it is We who sent down the Quran, and indeed, We will be its guardian." — Surah Al-Hijr, 15:9

Built with love for the Ummah.