import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/api.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'event.dart';
part 'state.dart';

class WatchlistPageBloc extends Bloc<WatchlistPageEvent, WatchlistPageState> {
  SortBy sortBy;
  OrderBy orderBy;
  CountryList countries;

  @override
  WatchlistPageState get initialState => Uninitialized();

  @override
  Stream<WatchlistPageState> mapEventToState(
    WatchlistPageEvent event,
  ) async* {
    if (event is LoadCountryList) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> watchlist = prefs.getStringList('watchlist') ?? List();

      int sortByIndex = 0;
      int orderByIndex = 0;
      List<CountryStats> countriesList = event.countries.list;
      countriesList = countriesList.where((countryStat) {
        return watchlist.contains(countryStat.country);
      }).toList();

      countries = CountryList(list: countriesList);
      sort(
        countries.list,
        SortBy.values[sortByIndex],
        OrderBy.values[orderByIndex],
      );

      sortBy = SortBy.values[sortByIndex];
      orderBy = OrderBy.values[orderByIndex];

      yield Loaded(
        countries: countries,
      );
    } else if (event is SortCountryList) {
      sort(
        countries.list,
        event.sortBy,
        orderBy,
      );
      sortBy = event.sortBy;

      yield Loaded(
        countries: countries,
      );
    } else if (event is OrderCountryList) {
      sort(
        countries.list,
        sortBy,
        event.orderBy,
      );
      orderBy = event.orderBy;

      yield Loaded(
        countries: countries,
      );
    } else {
      getLogger().wtf('Something went wrong.');
    }
  }

  void sort(List list, SortBy sortBy, OrderBy orderBy) {
    if (SortBy.totalCases == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.cases - b.cases);
      else
        list.sort((a, b) => b.cases - a.cases);
    } else if (SortBy.mild == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.mild - b.mild);
      else
        list.sort((a, b) => b.mild - a.mild);
    } else if (SortBy.critical == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.critical - b.critical);
      else
        list.sort((a, b) => b.critical - a.critical);
    } else if (SortBy.recovered == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.recovered - b.recovered);
      else
        list.sort((a, b) => b.recovered - a.recovered);
    } else if (SortBy.deaths == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.deaths - b.deaths);
      else
        list.sort((a, b) => b.deaths - a.deaths);
    } else if (SortBy.newCases == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.todayCases - b.todayCases);
      else
        list.sort((a, b) => b.todayCases - a.todayCases);
    } else if (SortBy.newDeaths == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.todayDeaths - b.todayDeaths);
      else
        list.sort((a, b) => b.todayDeaths - a.todayDeaths);
    } else if (SortBy.casesPerMillion == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) =>
            (a.casesPerMillion * 100).toInt() -
            (b.casesPerMillion * 100).toInt());
      else
        list.sort((a, b) =>
            (b.casesPerMillion * 100).toInt() -
            (a.casesPerMillion * 100).toInt());
    } else if (SortBy.deathsPerMillion == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) =>
            (a.deathsPerMillion * 100).toInt() -
            (b.deathsPerMillion * 100).toInt());
      else
        list.sort((a, b) =>
            (b.deathsPerMillion * 100).toInt() -
            (a.deathsPerMillion * 100).toInt());
    } else if (SortBy.testsPerMillion == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) =>
            (a.testsPerMillion * 100).toInt() -
            (b.testsPerMillion * 100).toInt());
      else
        list.sort((a, b) =>
            (b.testsPerMillion * 100).toInt() -
            (a.testsPerMillion * 100).toInt());
    } else if (SortBy.tests == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.tests - b.tests);
      else
        list.sort((a, b) => b.tests - a.tests);
    } else if (SortBy.alphabetical == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => b.country.compareTo(a.country));
      else
        list.sort((a, b) => a.country.compareTo(b.country));
    }
  }
}
