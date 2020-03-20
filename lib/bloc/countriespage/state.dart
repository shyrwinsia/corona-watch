part of 'bloc.dart';

abstract class CountriesPageState extends Equatable {
  const CountriesPageState();
}

class Uninitialized extends CountriesPageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] CountriesPageState: Uninitialized';
}

class Loading extends CountriesPageState {
  @override
  List<Object> get props => null;

  @override
  String toString() => '[State] CountriesPageState: Loading';
}

class Loaded extends CountriesPageState {
  final CountryList countries;
  final SortBy sortBy;

  Loaded({this.countries, this.sortBy});

  @override
  String toString() => '[State] CountriesPageState: Loaded';

  List<Object> get props => [this.countries];
}

class Wtf extends CountriesPageState {
  final RestApiException exception;

  Wtf({this.exception});

  @override
  String toString() => '[State] CountriesPageState: Wtf {$exception}';

  List<Object> get props => [this.exception];
}
