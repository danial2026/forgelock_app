import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @appName.
  ///
  /// In ja, this message translates to:
  /// **'ForgeLock'**
  String get appName;

  /// No description provided for @serverNotResponding.
  ///
  /// In ja, this message translates to:
  /// **'サーバーが応答していません'**
  String get serverNotResponding;

  /// No description provided for @serverNotRespondingDescription.
  ///
  /// In ja, this message translates to:
  /// **'サーバーが応答していません。後でもう一度お試しください。'**
  String get serverNotRespondingDescription;

  /// No description provided for @tryAgain.
  ///
  /// In ja, this message translates to:
  /// **'もう一度試す'**
  String get tryAgain;

  /// No description provided for @settings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In ja, this message translates to:
  /// **'テーマ'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In ja, this message translates to:
  /// **'システムテーマ'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In ja, this message translates to:
  /// **'ライトテーマ'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In ja, this message translates to:
  /// **'ダークテーマ'**
  String get darkTheme;

  /// No description provided for @language.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get language;

  /// No description provided for @english.
  ///
  /// In ja, this message translates to:
  /// **'英語'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @font.
  ///
  /// In ja, this message translates to:
  /// **'フォント'**
  String get font;

  /// No description provided for @doYouWantToExit.
  ///
  /// In ja, this message translates to:
  /// **'終了しますか？'**
  String get doYouWantToExit;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @password.
  ///
  /// In ja, this message translates to:
  /// **'パスワード'**
  String get password;

  /// No description provided for @passwordCopiedToClipboard.
  ///
  /// In ja, this message translates to:
  /// **'パスワードをクリップボードにコピーしました'**
  String get passwordCopiedToClipboard;

  /// No description provided for @generatedInMs.
  ///
  /// In ja, this message translates to:
  /// **'{ms}ミリ秒で生成されました'**
  String generatedInMs(int ms);

  /// No description provided for @done.
  ///
  /// In ja, this message translates to:
  /// **'完了'**
  String get done;

  /// No description provided for @reset.
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get reset;

  /// No description provided for @textFields.
  ///
  /// In ja, this message translates to:
  /// **'テキストフィールド'**
  String get textFields;

  /// No description provided for @dateFields.
  ///
  /// In ja, this message translates to:
  /// **'日付フィールド'**
  String get dateFields;

  /// No description provided for @numberFields.
  ///
  /// In ja, this message translates to:
  /// **'数値フィールド'**
  String get numberFields;

  /// No description provided for @generatePassword.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを生成'**
  String get generatePassword;

  /// No description provided for @hasSpecialChars.
  ///
  /// In ja, this message translates to:
  /// **'特殊文字を含む'**
  String get hasSpecialChars;

  /// No description provided for @firstWordOrPhrase.
  ///
  /// In ja, this message translates to:
  /// **'1番目の単語またはフレーズ'**
  String get firstWordOrPhrase;

  /// No description provided for @secondWordOrPhrase.
  ///
  /// In ja, this message translates to:
  /// **'2番目の単語またはフレーズ'**
  String get secondWordOrPhrase;

  /// No description provided for @nthWordOrPhrase.
  ///
  /// In ja, this message translates to:
  /// **'{n}番目の単語またはフレーズ'**
  String nthWordOrPhrase(int n);

  /// No description provided for @customWordOrPhrase.
  ///
  /// In ja, this message translates to:
  /// **'カスタムの単語またはフレーズ'**
  String get customWordOrPhrase;

  /// No description provided for @selectDate.
  ///
  /// In ja, this message translates to:
  /// **'日付を選択'**
  String get selectDate;

  /// No description provided for @firstNumber.
  ///
  /// In ja, this message translates to:
  /// **'1番目の数字'**
  String get firstNumber;

  /// No description provided for @secondNumber.
  ///
  /// In ja, this message translates to:
  /// **'2番目の数字'**
  String get secondNumber;

  /// No description provided for @nthNumber.
  ///
  /// In ja, this message translates to:
  /// **'{n}番目の数字'**
  String nthNumber(int n);

  /// No description provided for @customNumber.
  ///
  /// In ja, this message translates to:
  /// **'カスタムの数字'**
  String get customNumber;

  /// No description provided for @passwordLength.
  ///
  /// In ja, this message translates to:
  /// **'パスワードの長さ'**
  String get passwordLength;

  /// No description provided for @visitWebsite.
  ///
  /// In ja, this message translates to:
  /// **'🌐 ウェブサイトを訪問'**
  String get visitWebsite;

  /// No description provided for @developerWebsite.
  ///
  /// In ja, this message translates to:
  /// **'🌐 開発者のウェブサイト'**
  String get developerWebsite;

  /// No description provided for @contactDeveloper.
  ///
  /// In ja, this message translates to:
  /// **'📧 開発者に連絡'**
  String get contactDeveloper;

  /// No description provided for @sourceCode.
  ///
  /// In ja, this message translates to:
  /// **'💻 ソースコード'**
  String get sourceCode;

  /// No description provided for @termsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
