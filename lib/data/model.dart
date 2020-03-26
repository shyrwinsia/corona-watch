class AppModel {
  final GlobalStats globalStats;
  final CountryList countryList;

  AppModel({
    this.globalStats,
    this.countryList,
  });
}

class GlobalStats {
  final int cases;
  final int active;
  final int deaths;
  final int recovered;
  final DateTime updated;

  GlobalStats({
    this.cases,
    this.deaths,
    this.recovered,
    updated,
  })  : this.active = cases - deaths - recovered,
        this.updated = DateTime.fromMillisecondsSinceEpoch(updated);

  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    return GlobalStats(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
      updated: json['updated'],
    );
  }
}

class CountryList {
  final List<CountryStats> list;

  CountryList({this.list});

  factory CountryList.fromJson(List<dynamic> json) {
    List<CountryStats> list = List();
    for (Map<String, dynamic> item in json) {
      list.add(CountryStats.fromJson(item));
    }
    return CountryList(list: list);
  }
}

class CountryStats {
  final String country;
  final int cases;
  final int deaths;
  final int todayCases;
  final int todayDeaths;
  final int recovered;
  final int active;
  final String iso2;

  CountryStats({
    country,
    this.cases = 0,
    this.deaths = 0,
    this.todayCases = 0,
    this.todayDeaths = 0,
    this.recovered = 0,
    this.iso2 = 'XX',
  })  : this.country = country.split(',')[0],
        this.active = cases - deaths - recovered;

  factory CountryStats.fromJson(Map<String, dynamic> json) {
    return CountryStats(
      country: json['country'],
      cases: json['cases'],
      deaths: json['deaths'],
      todayCases: json['todayCases'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      iso2: json['countryInfo']['iso2'],
    );
  }
}

class Stats {
  final DateTime lastFetch;
  final CountryStats countryStats;
  final GlobalStats globalStats;

  Stats({this.globalStats, this.countryStats})
      : this.lastFetch = DateTime.now();
}

class SortParams {
  final SortBy sortBy;
  final OrderBy orderBy;

  SortParams({this.sortBy, this.orderBy});
}

enum SortBy {
  totalCases,
  active,
  deaths,
  newActive,
  newDeaths,
  recovered,
  alphabetical,
}
enum OrderBy { highestFirst, lowestFirst }

const WORLDOMETERS_URL = "https://www.worldometers.info/coronavirus/";
