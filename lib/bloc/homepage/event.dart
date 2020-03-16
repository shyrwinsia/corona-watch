part of 'bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();
}

class LoadGlobalStats extends HomePageEvent {
  final GlobalStats stats;

  LoadGlobalStats({this.stats});

  @override
  String toString() => '[Event] HomePageEvent: LoadGlobalStats';

  @override
  List<Object> get props => null;
}
