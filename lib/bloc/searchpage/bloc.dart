import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  CountryList countries;

  @override
  SearchPageState get initialState => Uninitialized();

  @override
  Stream<SearchPageState> mapEventToState(
    SearchPageEvent event,
  ) async* {
    if (event is LoadSearchPage) {
      this.countries = event.countries;
      yield Loaded(countries: CountryList(list: List()));
    } else if (event is SearchCountry) {
      String searchString = event.name;

      if (searchString.length < 3 && searchString.length > 0) {
        List<CountryStats> list = List();
        for (CountryStats country in countries.list) {
          if (country.country
              .toLowerCase()
              .startsWith(searchString.toLowerCase())) list.add(country);
        }
        yield Loaded(countries: CountryList(list: list));
      } else if (searchString.length >= 3) {
        List<CountryStats> list = List();
        for (CountryStats country in countries.list) {
          if (country.country
              .toLowerCase()
              .contains(searchString.toLowerCase())) list.add(country);
        }
        yield Loaded(countries: CountryList(list: list));
      } else {
        yield Loaded(countries: CountryList(list: List()));
      }
    } else {
      getLogger().wtf('Something went wrong.');
    }
  }
}
