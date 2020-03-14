class GlobalStats {
  final int cases;
  final int active;
  final int deaths;
  final int recovered;

  GlobalStats({
    this.cases,
    this.deaths,
    this.recovered,
  }) : this.active = cases - deaths - recovered;

  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    return GlobalStats(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
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

  CountryStats({
    this.country,
    cases = 0,
    this.deaths = 0,
    this.todayCases = 0,
    this.todayDeaths = 0,
    this.recovered = 0,
  })  : this.active = cases - deaths - recovered,
        this.cases = cases + todayCases;

  factory CountryStats.fromJson(Map<String, dynamic> json) {
    return CountryStats(
      country: json['country'],
      cases: json['cases'],
      deaths: json['deaths'],
      todayCases: json['todayCases'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
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
