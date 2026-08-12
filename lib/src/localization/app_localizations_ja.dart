// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'ForgeLock';

  @override
  String get serverNotResponding => 'サーバーが応答していません';

  @override
  String get serverNotRespondingDescription => 'サーバーが応答していません。後でもう一度お試しください。';

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get settings => '設定';

  @override
  String get theme => 'テーマ';

  @override
  String get systemTheme => 'システムテーマ';

  @override
  String get lightTheme => 'ライトテーマ';

  @override
  String get darkTheme => 'ダークテーマ';

  @override
  String get language => '言語';

  @override
  String get english => '英語';

  @override
  String get japanese => '日本語';

  @override
  String get font => 'フォント';

  @override
  String get doYouWantToExit => '終了しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get password => 'パスワード';

  @override
  String get passwordCopiedToClipboard => 'パスワードをクリップボードにコピーしました';

  @override
  String generatedInMs(int ms) {
    return '$msミリ秒で生成されました';
  }

  @override
  String get done => '完了';

  @override
  String get reset => 'リセット';

  @override
  String get textFields => 'テキストフィールド';

  @override
  String get dateFields => '日付フィールド';

  @override
  String get numberFields => '数値フィールド';

  @override
  String get generatePassword => 'パスワードを生成';

  @override
  String get hasSpecialChars => '特殊文字を含む';

  @override
  String get firstWordOrPhrase => '1番目の単語またはフレーズ';

  @override
  String get secondWordOrPhrase => '2番目の単語またはフレーズ';

  @override
  String nthWordOrPhrase(int n) {
    return '$n番目の単語またはフレーズ';
  }

  @override
  String get customWordOrPhrase => 'カスタムの単語またはフレーズ';

  @override
  String get selectDate => '日付を選択';

  @override
  String get firstNumber => '1番目の数字';

  @override
  String get secondNumber => '2番目の数字';

  @override
  String nthNumber(int n) {
    return '$n番目の数字';
  }

  @override
  String get customNumber => 'カスタムの数字';

  @override
  String get passwordLength => 'パスワードの長さ';

  @override
  String get visitWebsite => '🌐 ウェブサイトを訪問';

  @override
  String get developerWebsite => '🌐 開発者のウェブサイト';

  @override
  String get contactDeveloper => '📧 開発者に連絡';

  @override
  String get sourceCode => '💻 ソースコード';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';
}
