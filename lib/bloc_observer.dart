import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class Observe extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log(bloc.state.toString());
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    log(bloc.state.toString());
    super.onClose(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('${bloc.runtimeType} $transition');
  }
}
