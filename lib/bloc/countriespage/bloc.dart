import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/api.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';

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
      // load the params from sharepref
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // int sortByIndex = pref.getInt('sortBy') ?? 0;
      // int orderByIndex = pref.getInt('orderBy') ?? 0;

      // sort(
      //   event.countries.list,
      //   SortBy.values[sortByIndex],
      //   OrderBy.values[orderByIndex],
      // );

      yield Loaded(
        countries: event.countries,
        sortBy: SortBy.active,
        // sortBy: SortBy.values[sortByIndex],
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
    } else if (SortBy.active == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.active - b.active);
      else
        list.sort((a, b) => b.active - a.active);
    } else if (SortBy.deaths == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.deaths - b.deaths);
      else
        list.sort((a, b) => b.deaths - a.deaths);
    } else if (SortBy.newActive == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.todayCases - b.todayCases);
      else
        list.sort((a, b) => b.todayCases - a.todayCases);
    } else if (SortBy.newDeaths == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.todayDeaths - b.todayDeaths);
      else
        list.sort((a, b) => b.todayDeaths - a.todayDeaths);
    } else if (SortBy.recovered == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => a.recovered - b.recovered);
      else
        list.sort((a, b) => b.recovered - a.recovered);
    } else if (SortBy.alphabetical == sortBy) {
      if (OrderBy.lowestFirst == orderBy)
        list.sort((a, b) => b.country.compareTo(a.country));
      else
        list.sort((a, b) => a.country.compareTo(b.country));
    }
  }
}
