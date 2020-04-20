part of 'bloc.dart';

abstract class CountryDetailsPageState extends Equatable {
  const CountryDetailsPageState();
}

class Uninitialized extends CountryDetailsPageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] CountryDetailsPageState: Uninitialized';
}

class Loaded extends CountryDetailsPageState {
  final bool inWatchlist;

  Loaded({this.inWatchlist});

  @override
  String toString() => '[State] CountryDetailsPageState: Loaded';

  List<Object> get props => [this.inWatchlist];
}

class AddedToWatchlist extends CountryDetailsPageState {
  @override
  String toString() => '[State] CountryDetailsPageState: AddedToWatchlist';

  List<Object> get props => null;
}

class RemovedFromWatchlist extends CountryDetailsPageState {
  @override
  String toString() => '[State] CountryDetailsPageState: RemovedFromWatchlist';

  List<Object> get props => null;
}
