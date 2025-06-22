part of 'home_bloc.dart';

@freezed
class ListUserEvent with _$ListUserEvent {
  const factory ListUserEvent.get() = _Get;
  const factory ListUserEvent.loadMore() = _LoadMore;
}
