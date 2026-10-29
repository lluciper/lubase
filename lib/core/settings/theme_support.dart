import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The app brightness, in `getIt`; `App` rebuilds when it changes.
class ThemeCubit extends Cubit<Brightness> {
  ThemeCubit() : super(Brightness.light);

  void setBrightness(Brightness brightness) {
    emit(brightness);
  }

  void clearBrightness() {
    emit(Brightness.light);
  }
}
