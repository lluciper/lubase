import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spash_event.dart';
part 'spash_state.dart';

class SpashBloc extends Bloc<SpashEvent, SpashState> {
  SpashBloc() : super(SpashInitial()) {
    on<SpashEvent>((event, emit) {
      
      if (event is SpashStarted) {
        // Handle the splash screen start event
        // You can add your logic here, such as navigating to another screen
        // or performing some initialization tasks.
        print('Splash screen started');
        emit(SpashInitial());
      }
    });
  }
}
