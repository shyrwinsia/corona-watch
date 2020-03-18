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
  final CovidStats stats;

  Loaded({this.stats});

  @override
  String toString() => '[State] HomePageState: Loaded';

  List<Object> get props => [this.stats];
}

class Wtf extends HomePageState {
  final RestApiException exception;

  Wtf({this.exception});

  @override
  String toString() => '[State] HomePageState: Wtf {$exception}';

  List<Object> get props => [this.exception];
}
