import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'event.dart';
part 'state.dart';

class CountryDetailsPageBloc
    extends Bloc<CountryDetailsPageEvent, CountryDetailsPageState> {
  SortBy sortBy;
  OrderBy orderBy;
  CountryList countries;

  @override
  CountryDetailsPageState get initialState => Uninitialized();

  @override
  Stream<CountryDetailsPageState> mapEventToState(
    CountryDetailsPageEvent event,
  ) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList('watchlist') ?? List();
    if (event is LoadCountryDetail) {
      yield Loaded(inWatchlist: watchlist.contains(event.name));
    } else if (event is AddToWatchlist) {
      if (!watchlist.contains(event.name)) {
        watchlist.add(event.name);
        prefs.setStringList('watchlist', watchlist);
      }
      yield AddedToWatchlist();
      yield Loaded(inWatchlist: true);
    } else if (event is RemoveFromWatchlist) {
      if (watchlist.contains(event.name)) {
        watchlist.remove(event.name);
        prefs.setStringList('watchlist', watchlist);
      }
      yield RemovedFromWatchlist();
      // update save
      yield Loaded(inWatchlist: false);
    } else {
      getLogger().wtf('Something went wrong.');
    }
  }
}
