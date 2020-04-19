import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/api.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';

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
    if (event is LoadCountryDetail) {
      // String name = event.name;
      // search the name here

      yield Loaded(inWatchlist: false);
    } else if (event is AddToWatchlist) {
      yield AddedToWatchlist();
      // update save
      yield Loaded(inWatchlist: true);
    } else if (event is RemoveFromWatchList) {
      yield RemovedFromWatchlist();
      // update save
      yield Loaded(inWatchlist: false);
    } else {
      getLogger().wtf('Something went wrong.');
    }
  }
}
