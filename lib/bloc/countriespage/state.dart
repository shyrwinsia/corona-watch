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

class Loaded extends CountriesPageState {
  final CountryList countries;

  Loaded({this.countries});

  @override
  String toString() => '[State] CountriesPageState: Loaded';

  List<Object> get props => [this.countries];
}
