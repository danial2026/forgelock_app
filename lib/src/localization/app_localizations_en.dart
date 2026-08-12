// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ForgeLock';

  @override
  String get serverNotResponding => 'Server Not Responding';

  @override
  String get serverNotRespondingDescription =>
      'The server is not responding. Please try again later.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get font => 'Font';

  @override
  String get doYouWantToExit => 'Do you want to exit?';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get password => 'Password';

  @override
  String get passwordCopiedToClipboard => 'Password copied to clipboard';

  @override
  String generatedInMs(int ms) {
    return 'Generated in ${ms}ms';
  }

  @override
  String get done => 'Done';

  @override
  String get reset => 'Reset';

  @override
  String get textFields => 'Text Fields';

  @override
  String get dateFields => 'Date Fields';

  @override
  String get numberFields => 'Number Fields';

  @override
  String get generatePassword => 'Generate Password';

  @override
  String get hasSpecialChars => 'Has Special Chars';

  @override
  String get firstWordOrPhrase => 'first word or phrase';

  @override
  String get secondWordOrPhrase => '2nd word or phrase';

  @override
  String nthWordOrPhrase(int n) {
    return '${n}th word or phrase';
  }

  @override
  String get customWordOrPhrase => 'custom word or phrase';

  @override
  String get selectDate => 'Select Date';

  @override
  String get firstNumber => 'first number';

  @override
  String get secondNumber => '2nd number';

  @override
  String nthNumber(int n) {
    return '${n}th number';
  }

  @override
  String get customNumber => 'custom number';

  @override
  String get passwordLength => 'Password Length';

  @override
  String get visitWebsite => '🌐 Visit Website';

  @override
  String get developerWebsite => '🌐 Developer Website';

  @override
  String get contactDeveloper => '📧 Contact Developer';

  @override
  String get sourceCode => '💻 Source Code';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';
}
