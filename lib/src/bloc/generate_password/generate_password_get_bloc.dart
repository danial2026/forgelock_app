import 'dart:math';

import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgelock/src/bloc/generate_password/generate_password_response_model.dart';
import 'package:forgelock/src/bloc/custom_bloc_event.dart';
import 'package:forgelock/src/bloc/custom_bloc_exception.dart';
import 'package:forgelock/src/bloc/custom_bloc_state.dart';
import 'package:forgelock/src/helpers/logger/logger_helper.dart';

class PasswordGeneratorBloc extends _PasswordGeneratorBloc {
  PasswordGeneratorBloc() : super();
}

abstract class _PasswordGeneratorBloc extends Bloc<PasswordGeneratorEvent, PasswordGeneratorState> {
  _PasswordGeneratorBloc() : super(const PasswordGeneratorInitial()) {
    on<_PasswordGenerateRequested>(_mapRequestedToState);
  }

  // Secure salt that should be stored securely in your app
  static const String _specialChars = "!@#\$%^&*()_+-=[]{}|;:,.<>?/~";

  String _generateSalt(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Generate salt from inputs
    final input = strings.join() + numbers.join() + dates.map((d) => d.millisecondsSinceEpoch).join();
    final hash = sha256.convert(utf8.encode(input));
    return base64Url.encode(hash.bytes).substring(0, 32); // 32 char salt
  }

  String _algorithm1(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // HMAC-SHA512 based algorithm
    final input = strings.join() + numbers.join() + dates.map((d) => d.millisecondsSinceEpoch).join();
    final key = utf8.encode(_generateSalt(strings, numbers, dates));
    final bytes = utf8.encode(input);
    final hmac = Hmac(sha512, key);
    final digest = hmac.convert(bytes);
    return digest.toString().substring(0, 16); // Take first 16 chars
  }

  String _algorithm2(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Argon2-inspired multiple mixing rounds
    var combined = strings.join() + _generateSalt(strings, numbers, dates) + numbers.join() + dates.map((d) => d.toIso8601String()).join();
    for (var i = 0; i < 1000; i++) {
      combined = sha256.convert(utf8.encode(combined)).toString();
    }
    return combined.substring(0, 16);
  }

  String _algorithm3(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // XOR-based mixing with SHA-384
    final input = strings.join() + numbers.join() + dates.map((d) => d.millisecondsSinceEpoch).join();
    var result = sha384.convert(utf8.encode(input + _generateSalt(strings, numbers, dates))).bytes;
    for (var i = 0; i < result.length - 1; i++) {
      result[i] ^= result[i + 1];
    }
    return base64Url.encode(result).substring(0, 16);
  }

  String _algorithm4(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Cascading hash function with position-based salt
    var result = "";
    final input = strings.join() + numbers.join() + dates.map((d) => d.toIso8601String()).join();
    for (var i = 0; i < 4; i++) {
      final positionSalt = _generateSalt(strings, numbers, dates) + i.toString();
      final hash = sha256.convert(utf8.encode(input + positionSalt)).toString();
      // Ensure we don't exceed string length
      final startPos = (i * 4) % (hash.length - 4);
      result += hash.substring(startPos, startPos + 4);
    }
    return result;
  }

  String _algorithm5(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Interleaved mixing with multiple hash functions
    final input1 = sha256.convert(utf8.encode(strings.join() + _generateSalt(strings, numbers, dates)));
    final input2 = sha512.convert(utf8.encode(numbers.join() + _generateSalt(strings, numbers, dates)));
    final input3 = sha384.convert(utf8.encode(dates.map((d) => d.millisecondsSinceEpoch).join() + _generateSalt(strings, numbers, dates)));

    var result = "";
    for (var i = 0; i < 12; i += 3) {
      result += input1.toString()[i % input1.toString().length];
      result += input2.toString()[i % input2.toString().length];
      result += input3.toString()[i % input3.toString().length];
    }
    return result.padRight(16, '0');
  }

  String _algorithm6(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Time-based mixing with rolling hash
    var hash = 0;
    final input = strings.join() + numbers.join() + dates.map((d) => d.millisecondsSinceEpoch).join();
    for (var i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash) + input.codeUnitAt(i);
      hash = hash & hash;
    }
    final finalInput = hash.toString() + _generateSalt(strings, numbers, dates) + input;
    return sha512.convert(utf8.encode(finalInput)).toString().substring(0, 16);
  }

  String _algorithm7(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Block cipher simulation with SHA-3
    final blocks = <String>[];
    blocks.add(strings.join());
    blocks.add(numbers.join());
    blocks.add(dates.map((d) => d.millisecondsSinceEpoch).join());

    var previousHash = _generateSalt(strings, numbers, dates);
    var result = "";
    for (final block in blocks) {
      previousHash = sha512.convert(utf8.encode(previousHash + block)).toString();
      // Take first 5 chars safely
      result += previousHash.substring(0, 5);
    }
    return result.substring(0, min(16, result.length));
  }

  String _algorithm8(List<String> strings, List<int> numbers, List<DateTime> dates) {
    // Multi-layer perceptron inspired hashing
    var layer1 = strings.join() + _generateSalt(strings, numbers, dates);
    var layer2 = numbers.join() + _generateSalt(strings, numbers, dates);
    var layer3 = dates.map((d) => d.millisecondsSinceEpoch).join() + _generateSalt(strings, numbers, dates);

    layer1 = sha256.convert(utf8.encode(layer1)).toString();
    layer2 = sha384.convert(utf8.encode(layer2 + layer1)).toString();
    layer3 = sha512.convert(utf8.encode(layer3 + layer2)).toString();

    final combined = layer1 + layer2 + layer3;
    return combined.substring(0, min(16, combined.length));
  }

  String generateUltraSecurePassword(List<String> strings, List<int> numbers, List<DateTime> dates,
      {bool hasSpecialChars = true, int length = 16}) {
    // Phase 1: Initial mixing using all previous algorithms
    final results = [
      _algorithm1(strings, numbers, dates),
      _algorithm1(strings, numbers, dates),
      _algorithm2(strings, numbers, dates),
      _algorithm3(strings, numbers, dates),
      _algorithm4(strings, numbers, dates),
      _algorithm5(strings, numbers, dates),
      _algorithm6(strings, numbers, dates),
      _algorithm7(strings, numbers, dates),
      _algorithm8(strings, numbers, dates),
    ];

    // Phase 2: Complex intermixing
    var masterHash = "";
    for (var i = 0; i < results.length; i++) {
      final nextIndex = (i + 1) % results.length;
      final combined = results[i] + _generateSalt(strings, numbers, dates) + results[nextIndex];
      masterHash += sha512.convert(utf8.encode(combined)).toString();
    }

    // Phase 3: Character mapping and transformation
    final List<int> charCodes = [];
    for (var i = 0; i < masterHash.length - 1; i += 2) {
      // Added -1 to prevent overflow
      final value = int.parse(masterHash.substring(i, i + 2), radix: 16);
      charCodes.add(value);
    }

    // Phase 4: Build password with specific character types
    final StringBuffer password = StringBuffer();

    // Generate length characters using deterministic values from charCodes
    for (var i = 0; i < length; i++) {
      final charType = charCodes[i % charCodes.length] % 4;
      final charCode = charCodes[(i + 1) % charCodes.length];

      switch (charType) {
        case 0: // Uppercase letter
          password.write(String.fromCharCode(65 + (charCode % 26)));
          break;
        case 1: // Lowercase letter
          password.write(String.fromCharCode(97 + (charCode % 26)));
          break;
        case 2: // Number
          password.write(charCode % 10);
          break;
        case 3: // Special character
          if (hasSpecialChars) {
            password.write(_specialChars[charCode % _specialChars.length]);
          } else {
            password.write(charCode % 10);
          }
          break;
      }
    }

    // Phase 5: Final transformation
    final String rawPassword = password.toString();
    final List<String> chars = rawPassword.split('');

    // Ensure minimum requirements
    chars[0] = chars[0].toUpperCase(); // First char uppercase
    chars[1] = hasSpecialChars ? _specialChars[charCodes[0] % _specialChars.length] : (charCodes[0] % 10).toString(); // Second char special
    chars[2] = (charCodes[1] % 10).toString(); // Third char number

    // Additional mixing based on input data
    for (var i = 3; i < chars.length; i++) {
      if (i % 5 == 0) {
        // Every 5th character becomes special
        chars[i] = hasSpecialChars
            ? _specialChars[charCodes[i % charCodes.length] % _specialChars.length]
            : (charCodes[i % charCodes.length] % 10).toString();
      } else if (i % 7 == 0) {
        // Every 7th character becomes a number
        chars[i] = (charCodes[i % charCodes.length] % 10).toString();
      } else if (i % 3 == 0) {
        // Every 3rd character alternates case
        chars[i] = i % 6 == 0 ? chars[i].toUpperCase() : chars[i].toLowerCase();
      }
    }

    // Phase 6: Final security measures
    final finalPass = chars.join();
    final validator = sha384.convert(utf8.encode(finalPass + _generateSalt(strings, numbers, dates)));

    // If validator hash starts with '0', add extra transformation
    if (validator.toString().startsWith('0') && hasSpecialChars) {
      return _extraTransform(finalPass, charCodes);
    }

    return finalPass;
  }

  String _extraTransform(String password, List<int> charCodes) {
    final List<String> chars = password.split('');
    for (var i = 0; i < chars.length; i++) {
      if (i % 4 == 0) {
        final specialIndex = charCodes[i % charCodes.length] % _specialChars.length;
        chars[i] = _specialChars[specialIndex];
      }
    }
    return chars.join();
  }

  Future<void> _mapRequestedToState(_PasswordGenerateRequested event, Emitter<PasswordGeneratorState> emit) async {
    emit(const PasswordGeneratorInProgress());

    try {
      final stopwatch = Stopwatch()..start();
      final password = generateUltraSecurePassword(event.strings, event.numbers, event.dates,
          hasSpecialChars: event.hasSpecialChars, length: event.length);
      final elapsed = stopwatch.elapsed;
      LoggerHelper.debugLog('Password generation took: ${elapsed.inMilliseconds}ms');
      _mapRequestedToSuccess(
        event,
        emit,
        response: PasswordGeneratorResponseModel(
          password: password,
          time: elapsed.inMilliseconds,
        ),
      );
    } catch (e) {
      LoggerHelper.debugLog('Password generation failed: $e');
      emit(PasswordGeneratorFailure(error: CustomBlocException(e.toString())));
    }
  }

  void _mapRequestedToSuccess(_PasswordGenerateRequested event, Emitter<PasswordGeneratorState> emit,
      {required PasswordGeneratorResponseModel response}) {
    emit(PasswordGeneratorSuccess(
      item: response,
    ));
  }

  void requested({
    required List<String> strings,
    required List<DateTime> dates,
    required List<int> numbers,
    required int length,
    required bool hasSpecialChars,
  }) =>
      add(_PasswordGenerateRequested(
        strings: strings,
        dates: dates,
        numbers: numbers,
        length: length,
        hasSpecialChars: hasSpecialChars,
      ));
}

abstract class PasswordGeneratorEvent extends CustomBlocEvent {}

class _PasswordGenerateRequested extends PasswordGeneratorEvent {
  _PasswordGenerateRequested({
    required this.strings,
    required this.dates,
    required this.numbers,
    required this.length,
    required this.hasSpecialChars,
  });

  final List<String> strings;
  final List<DateTime> dates;
  final List<int> numbers;
  final int length;
  final bool hasSpecialChars;
}

abstract class PasswordGeneratorState extends CustomBlocState {
  const PasswordGeneratorState({required Status status}) : super(status: status);
}

class PasswordGeneratorInitial extends PasswordGeneratorState {
  const PasswordGeneratorInitial() : super(status: Status.Initial);

  @override
  String toString() => 'PasswordGeneratorInitial';
}

class PasswordGeneratorInProgress extends PasswordGeneratorState {
  const PasswordGeneratorInProgress() : super(status: Status.InProgress);

  @override
  String toString() => 'PasswordGeneratorInProgress';
}

class PasswordGeneratorSuccess extends PasswordGeneratorState {
  const PasswordGeneratorSuccess({required this.item}) : super(status: Status.Success);

  final PasswordGeneratorResponseModel item;

  @override
  String toString() => 'PasswordGeneratorSuccess';
}

class PasswordGeneratorFailure extends PasswordGeneratorState {
  const PasswordGeneratorFailure({this.error}) : super(status: Status.Failure);

  final CustomBlocException? error;
}
