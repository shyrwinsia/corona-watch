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
    try {
      final AppModel stats = await RestApi.fetch();
      yield Loaded(stats: stats);
    } on RestApiException catch (e) {
      yield Wtf(exception: e);
    }
  }
}
