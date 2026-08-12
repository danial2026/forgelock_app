# Myket Release Guide for ForgeLock

## Problem

ForgeLock was a **web-only** Flutter project (no `android/` platform directory) and had no release
signing setup. To publish on Myket you need a signed release APK + store-ready screenshots.

## Summary of what was done

1. Added the Android platform to the Flutter project
2. Set the application ID to `com.danials.forgelock` (namespace + MainActivity + manifest label)
3. Fixed localizations generation (Flutter 3.41 removed `synthetic-package`)
4. Generated a release keystore (RSA 4096, strong random password)
5. Wired release signing into Gradle via `android/key.properties`
6. Built and verified the signed release APK
7. Converted screenshots to Myket specs
8. Verified nothing sensitive leaks to the public repo

---

## Step 1 — Add the Android platform

```bash
flutter pub get
flutter create --platforms=android --no-pub --org com.danials .
```

Generated artifacts:
- `android/` (Gradle Kotlin DSL project)
- `android/app/src/main/kotlin/com/danials/forgelock/MainActivity.kt`
- `android/app/src/main/AndroidManifest.xml`

## Step 2 — Fix the application ID

`flutter create` generates `com.example.forgelock`. For a store release use a real ID:

```bash
# build.gradle.kts
namespace = "com.danials.forgelock"
defaultConfig { applicationId = "com.danials.forgelock" }

# move MainActivity.kt into the matching package path and update its `package` line
# AndroidManifest.xml: android:label="ForgeLock"
```

**Important:** the application ID cannot be changed after the first release — commit to it now.

## Step 3 — Fix localizations (Flutter 3.41+)

The app imports `package:flutter_gen/gen_l10n/app_localizations.dart`. The synthetic
`flutter_gen` package was **removed** in newer Flutter versions (see
https://flutter.dev/to/flutter-gen-deprecation), so:

1. Regenerate the files into the project (`l10n.yaml` points to `lib/src/localization/`):
   ```bash
   flutter gen-l10n
   ```
2. Replace the broken imports in all files:
   ```bash
   sed -i '' "s|package:flutter_gen/gen_l10n/app_localizations.dart|package:forgelock/src/localization/app_localizations.dart|g" \
     lib/src/view/page/app.dart \
     lib/src/view/page/home/home_page.dart \
     lib/src/view/page/splash_page.dart \
     lib/src/view/page/setting/setting_page.dart \
     lib/src/view/page/setting/privacy_policy_page.dart \
     lib/src/view/page/setting/terms_page.dart \
     lib/src/view/common/custom_scaffold.dart
   ```
3. Don't add `synthetic-package: true` to `l10n.yaml` — the option errors out on this SDK.

## Step 4 — Generate the release keystore

```bash
KEYTOOL="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool"

openssl rand -base64 48   # generate a strong password (use the output below)

$KEYTOOL -genkey -v \
  -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 4096 -validity 10000 \
  -alias upload \
  -storepass '<STRONG_PASSWORD>' \
  -keypass '<STRONG_PASSWORD>' \
  -dname "CN=Danial2026, OU=ForgeLock, O=ForgeLock, L=Unknown, S=Unknown, C=IR"
```

- Save the password somewhere safe — it cannot be recovered.
- The keystore is gitignored (`android/.gitignore` has `**/*.jks`).

## Step 5 — Create `android/key.properties` (never committed)

```properties
storePassword=<STRONG_PASSWORD>
keyPassword=<STRONG_PASSWORD>
keyAlias=upload
storeFile=app/upload-keystore.jks
```

## Step 6 — Wire release signing into `android/app/build.gradle.kts`

```kotlin
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    // ...
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
        }
    }

    applicationVariants.all {
        val variant = this
        variant.outputs.all {
            (this as com.android.build.gradle.internal.api.BaseVariantOutputImpl)
                .outputFileName = "forgelock-v${variant.versionName}-${name}.apk"
        }
    }
}
```

The APK is renamed to `forgelock-v{version}-release.apk` (version comes from pubspec: `0.1.2+6`).

## Step 7 — Build the signed release APK

```bash
flutter pub get                      # resolves deps (run once)
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" \
  ./gradlew assembleRelease          # run from android/
```

Output: `build/app/outputs/apk/release/forgelock-v0.1.2-release.apk` (~55 MB)

Verify the signature (must NOT say `CN=Android Debug`):

```bash
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" \
  "$HOME/Library/Android/sdk/build-tools/36.1.0/apksigner" verify --print-certs \
  build/app/outputs/apk/release/forgelock-v0.1.2-release.apk
```

## Step 8 — Convert screenshots to Myket specs

Myket requirements:
- at least **3** screenshots
- max width/height **3000 px**
- aspect ratio **16:9** or **9:16** (e.g. 1600x900)
- max **3 MB** per image

Use the bundled script (center-crops to exact ratio, keeps native resolution):

```bash
scripts/myket_screenshots.sh screenshots screenshots/myket
# override min-count via env if needed:
MIN_COUNT=1 scripts/myket_screenshots.sh screenshots screenshots/myket
```

Results: `screenshots/myket/*.png` — exact 9:16, 414x736, 32-36 KB.

> **NOTE:** Myket requires at least **3 screenshots** but the repo only has 2
> (`screenshot-main.png`, `screenshot-setting.png`). Take one more shot (e.g. login/
> onboarding) and rerun the script before submitting.

## Step 9 — Upload to Myket

1. [Myket developer panel](https://myket.ir/developer/panel) → select/create the app
2. Upload `build/app/outputs/apk/release/forgelock-v0.1.2-release.apk`
3. Upload ≥ 3 screenshots from `screenshots/myket/`
4. App name: ForgeLock — tagline suggestion (max 26 chars, Persian):
   - «قفل امنیت حسابهای شما» (count: ۱۲+…), choose one that fits
5. Description + changelog in Persian
6. Submit for review

## Security checklist (public repo)

- [x] `android/key.properties` — gitignored, never tracked
- [x] `android/app/upload-keystore.jks` — gitignored, never tracked
- [x] No passwords in any committed file
- [x] `build/` and `.dart_tool/` not tracked

Verify anytime:

```bash
git ls-files | grep -iE 'keystore|key\.properties|\.jks'   # must print nothing
```

## File summary

| File | Purpose | Git-tracked? |
|------|---------|--------------|
| `android/app/upload-keystore.jks` | Release signing key | No |
| `android/key.properties` | Keystore credentials for Gradle | No |
| `android/app/build.gradle.kts` | Signing config + build logic | Yes |
| `build/app/outputs/apk/release/forgelock-v*.apk` | Signed release APK | No |
| `scripts/myket_screenshots.sh` | Screenshot converter (Myket spec) | Yes |
| `screenshots/myket/` | Converted screenshots | New dir — commit if desired |