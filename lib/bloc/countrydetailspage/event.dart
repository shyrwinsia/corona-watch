part of 'bloc.dart';

abstract class CountryDetailsPageEvent extends Equatable {
  const CountryDetailsPageEvent();
}

class LoadCountryDetail extends CountryDetailsPageEvent {
  final String name;

  LoadCountryDetail({this.name});

  @override
  String toString() => '[Event] CountryDetailsPageEvent: LoadCountryDetail';

  @override
  List<Object> get props => [this.name];
}

class AddToWatchlist extends CountryDetailsPageEvent {
  final String name;

  AddToWatchlist({this.name});

  @override
  String toString() => '[Event] CountryDetailsPageEvent: AddToWatchlist $name';

  @override
  List<Object> get props => [this.name];
}

class RemoveFromWatchlist extends CountryDetailsPageEvent {
  final String name;

  RemoveFromWatchlist({this.name});

  @override
  String toString() =>
      '[Event] CountryDetailsPageEvent: RemoveFromWatchlist $name';

  @override
  List<Object> get props => [this.name];
}
