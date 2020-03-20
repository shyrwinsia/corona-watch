import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/api.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'event.dart';
part 'state.dart';

class CountriesPageBloc extends Bloc<CountriesPageEvent, CountriesPageState> {
  @override
  CountriesPageState get initialState => Uninitialized();

  @override
  Stream<CountriesPageState> mapEventToState(
    CountriesPageEvent event,
  ) async* {
    if (event is LoadCountryList) {
      yield Loading();
      yield* _loadCountries(event.countries);
    } else {
      getLogger().wtf('Something went wrong.');
    }
  }

  Stream<CountriesPageState> _loadCountries(CountryList countries) async* {
    try {
      final prefs = await SharedPreferences.getInstance();
      int sortByIndex = prefs.getInt('sortBy') ?? 0;
      int orderByIndex = prefs.getInt('orderBy') ?? 0;

      SortBy sortBy = SortBy.values[sortByIndex];
      OrderBy orderBy = OrderBy.values[orderByIndex];

      sort(countries.list, sortBy, orderBy);
      yield Loaded(countries: countries, sortBy: sortBy);
    } on RestApiException catch (e) {
      yield Wtf(exception: e);
    }
  }

  void sort(List list, SortBy sortBy, OrderBy orderBy) {
    if (SortBy.total == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => a.cases - b.cases);
      else
        list.sort((a, b) => b.cases - a.cases);
    } else if (SortBy.active == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => a.active - b.active);
      else
        list.sort((a, b) => b.active - a.active);
    } else if (SortBy.deaths == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => a.deaths - b.deaths);
      else
        list.sort((a, b) => b.deaths - a.deaths);
    } else if (SortBy.todayActive == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => a.todayCases - b.todayCases);
      else
        list.sort((a, b) => b.todayCases - a.todayCases);
    } else if (SortBy.todayDeaths == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => a.todayDeaths - b.todayDeaths);
      else
        list.sort((a, b) => b.todayDeaths - a.todayDeaths);
    } else if (SortBy.recovered == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => a.recovered - b.recovered);
      else
        list.sort((a, b) => b.recovered - a.recovered);
    } else if (SortBy.alphabetical == sortBy) {
      if (OrderBy.asc == orderBy)
        list.sort((a, b) => b.country.compareTo(a.country));
      else
        list.sort((a, b) => a.country.compareTo(b.country));
    }
  }
}
