part of 'bloc.dart';

abstract class WatchlistPageState extends Equatable {
  const WatchlistPageState();
}

class Uninitialized extends WatchlistPageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] WatchlistPageState: Uninitialized';
}

class Loaded extends WatchlistPageState {
  final CountryList countries;

  Loaded({this.countries});

  @override
  String toString() => '[State] WatchlistPageState: Loaded';

  List<Object> get props => [this.countries];
}

class Wtf extends WatchlistPageState {
  final RestApiException exception;

  Wtf({this.exception});

  @override
  String toString() => '[State] WatchlistPageState: Wtf {$exception}';

  List<Object> get props => [this.exception];
}
