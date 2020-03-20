part of 'bloc.dart';

abstract class CountriesPageEvent extends Equatable {
  const CountriesPageEvent();
}

class LoadCountryList extends CountriesPageEvent {
  final CountryList countries;

  LoadCountryList({this.countries});

  @override
  String toString() => '[Event] CountriesPageEvent: LoadCountryList';

  @override
  List<Object> get props => [this.countries];
}
