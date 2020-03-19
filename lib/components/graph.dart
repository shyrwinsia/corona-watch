import 'package:covidwatch/data/model.dart';
import 'package:covidwatch/extras/chart/pie_chart.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class GlobalGraph extends StatelessWidget {
  final Map<String, double> dataMap = Map();
  final GlobalStats stats;

  GlobalGraph(this.stats) {
    dataMap.putIfAbsent("active", () => stats.active.toDouble());
    dataMap.putIfAbsent("dead", () => stats.deaths.toDouble());
    dataMap.putIfAbsent("ok", () => stats.recovered.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CustomGraph(dataMap, "Worldwide"),
        SizedBox(height: 24),
        _StatTile(Color(0xffffffff), 'Total Cases', stats.cases),
        _StatTile(Color(0xfff5c76a), 'Active', stats.active),
        _StatTile(Color(0xffff653b), 'Deaths', stats.deaths),
        _StatTile(Color(0xff9ff794), 'Recovered', stats.recovered),
        SizedBox(height: 12),
        Text(
          'Last update ${timeago.format((stats.updated))}',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
        )
      ],
    );
  }
}

class CountryGraph extends StatelessWidget {
  final Map<String, double> dataMap = Map();
  final CountryStats stats;

  CountryGraph(this.stats) {
    dataMap.putIfAbsent("active", () => stats.active.toDouble());
    dataMap.putIfAbsent("dead", () => stats.deaths.toDouble());
    dataMap.putIfAbsent("ok", () => stats.recovered.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CustomGraph(dataMap, stats.country),
        SizedBox(height: 24),
        _StatTile(
          Color(0xffffffff),
          'Total Cases',
          stats.cases,
        ),
        _StatTile(
          Color(0xfff5c76a),
          'Active',
          stats.active,
          plus: stats.todayCases,
        ),
        _StatTile(
          Color(0xffff653b),
          'Deaths',
          stats.deaths,
          plus: stats.todayDeaths,
        ),
        _StatTile(
          Color(0xff9ff794),
          'Recovered',
          stats.recovered,
        )
      ],
    );
  }
}

class _CustomGraph extends StatelessWidget {
  final Map<String, double> dataMap;
  final String title;

  _CustomGraph(this.dataMap, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 1.6,
          showChartValuesInPercentage: true,
          showChartValues: false,
          showChartValuesOutside: true,
          colorList: [Color(0xfff5c76a), Color(0xffff653b), Color(0xff9ff794)],
          showLegends: false,
          decimalPlaces: 1,
          showChartValueLabel: true,
          initialAngle: 4.5,
          chartType: ChartType.ring,
          chartValueStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
          ),
          title: title,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final int plus;

  _StatTile(this.color, this.label, this.value, {this.plus = 0});

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(FeatherIcons.circle, color: color, size: 10),
              SizedBox(
                width: 6,
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
          (plus != 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                      Text(
                        value.toString().replaceAllMapped(reg, mathFunc),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        FeatherIcons.arrowUp,
                        size: 10,
                      ),
                      Text(
                        "${plus.toString().replaceAllMapped(reg, mathFunc)}",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ])
              : Text(
                  value.toString().replaceAllMapped(reg, mathFunc),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ],
      ),
    );
  }
}
