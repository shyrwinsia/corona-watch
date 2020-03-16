import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidwatch/data/api.dart';
import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/logger/logger.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  @override
  HomePageState get initialState => Uninitialized();

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is LoadGlobalStats) {
      yield Loading();
      yield* _fetchGlobal();
    } else {
      getLogger().wtf('Something went wrong.');
    }
  }

  Stream<HomePageState> _fetchGlobal() async* {
    final GlobalStats stats = await RestApi.fetchGlobal();
    yield Loaded(stats: stats);
  }
}
