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

class CountryStats {}

class Stats {
  final DateTime lastFetch;
  final CountryStats countryStats;
  final GlobalStats globalStats;

  Stats({this.globalStats, this.countryStats})
      : this.lastFetch = DateTime.now();
}
