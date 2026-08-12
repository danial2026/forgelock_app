import 'package:bloc/bloc.dart';

class CustomBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    var out = '----------------EVENT-------------------\n';
    out += '${transition.event}\n';
    out += '----------------STATE-------------------\n';
    out += '${transition.currentState}\n';
    out += '╚> ${transition.nextState}';
    print(out);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
