part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  final int activeIndex;
  final DateTime? timestamp;

  const HomeInitial({required this.activeIndex, this.timestamp});

  @override
  List<Object?> get props => [activeIndex, timestamp];
}

final class LockedApp extends HomeState {
  final bool locked;

  const LockedApp(this.locked);

  @override
  List<Object> get props => [locked];
}
