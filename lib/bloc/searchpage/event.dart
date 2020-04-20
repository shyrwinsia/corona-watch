part of 'bloc.dart';

abstract class SearchPageEvent extends Equatable {
  const SearchPageEvent();
}

class LoadSearchPage extends SearchPageEvent {
  final CountryList countries;

  LoadSearchPage({this.countries});

  @override
  String toString() => '[Event] SearchPageEvent: LoadSearchPage';

  @override
  List<Object> get props => [this.countries];
}

class SearchCountry extends SearchPageEvent {
  final String name;

  SearchCountry({this.name});

  @override
  String toString() => '[Event] SearchPageEvent: SearchCountry $name';

  @override
  List<Object> get props => [this.name];
}
