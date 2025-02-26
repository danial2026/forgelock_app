import 'package:flutter_dotenv/flutter_dotenv.dart';

final DotEnv _envDetails = DotEnv();

Future<void> load(String address) async {
  await _envDetails.load(fileName: address);
}

String read(String key) {
  return _envDetails.env[key]!;
}

// Read APP_ENV from parameter
// e.g. flutter run --dart-define=APP_ENV=staging
const _appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

// Read STORE_TYPE from parameter
// e.g. flutter run --dart-define=STORE_TYPE=direct
const _storeType = String.fromEnvironment('STORE_TYPE', defaultValue: 'direct');

AppEnv get appEnv => _appEnv == 'dev'
    ? AppEnv.dev
    : _appEnv == 'prod'
        ? AppEnv.prod
        : AppEnv.staging;

StoreType get storeType => _storeType == 'applestore'
    ? StoreType.applestore
    : _storeType == 'googleplay'
        ? StoreType.googleplay
        : StoreType.direct;

enum AppEnv {
  dev,
  staging,
  prod,
}

enum StoreType {
  applestore,
  googleplay,
  direct,
}
