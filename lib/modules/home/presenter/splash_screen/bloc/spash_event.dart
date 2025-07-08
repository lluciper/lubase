part of 'spash_bloc.dart';

sealed class SpashEvent extends Equatable {
  const SpashEvent();

  @override
  List<Object> get props => [];
}

class SpashStarted extends SpashEvent {
  const SpashStarted();
}
