part of 'bloc.dart';

abstract class SearchPageState extends Equatable {
  const SearchPageState();
}

class Uninitialized extends SearchPageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] SearchPageState: Uninitialized';
}

class Loaded extends SearchPageState {
  final CountryList countries;

  Loaded({this.countries});

  @override
  String toString() => '[State] SearchPageState: Loaded';

  List<Object> get props => [this.countries];
}
