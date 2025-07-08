part of 'spash_bloc.dart';

sealed class SpashState extends Equatable {
  const SpashState();
  
  @override
  List<Object> get props => [];
}

final class SpashInitial extends SpashState {}
