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

class SortCountryList extends CountriesPageEvent {
  final SortBy sortBy;

  SortCountryList({this.sortBy});

  @override
  String toString() => '[Event] CountriesPageEvent: SortCountryList $sortBy';

  @override
  List<Object> get props => [this.sortBy];
}

class OrderCountryList extends CountriesPageEvent {
  final OrderBy orderBy;

  OrderCountryList({this.orderBy});

  @override
  String toString() => '[Event] CountriesPageEvent: OrderCountryList $orderBy';

  @override
  List<Object> get props => [this.orderBy];
}
