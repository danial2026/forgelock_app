import 'package:bloc/bloc.dart';
import 'package:forgelock/src/bloc/custom_bloc_observer.dart';

Future<void> initBlocObserverAndStorage() async {
  Bloc.observer = CustomBlocObserver();
}
