part of 'bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();
}

class Uninitialized extends HomePageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] HomePageState: Uninitialized';
}

class Loading extends HomePageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] HomePageState: Loading';
}

class Loaded extends HomePageState {
  final GlobalStats stats;

  Loaded({this.stats});

  @override
  String toString() => '[State] HomePageState: Loaded';

  List<Object> get props => [this.stats];
}
