part of 'bloc.dart';

abstract class WatchlistPageEvent extends Equatable {
  const WatchlistPageEvent();
}

class LoadCountryList extends WatchlistPageEvent {
  final CountryList countries;

  LoadCountryList({this.countries});

  @override
  String toString() => '[Event] WatchlistPageEvent: LoadCountryList';

  @override
  List<Object> get props => [this.countries];
}

class SortCountryList extends WatchlistPageEvent {
  final SortBy sortBy;

  SortCountryList({this.sortBy});

  @override
  String toString() => '[Event] WatchlistPageEvent: SortCountryList $sortBy';

  @override
  List<Object> get props => [this.sortBy];
}

class OrderCountryList extends WatchlistPageEvent {
  final OrderBy orderBy;

  OrderCountryList({this.orderBy});

  @override
  String toString() => '[Event] WatchlistPageEvent: OrderCountryList $orderBy';

  @override
  List<Object> get props => [this.orderBy];
}
