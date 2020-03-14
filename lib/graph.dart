import 'package:covidwatch/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'chart/pie_chart.dart';

class GlobalGraph extends StatelessWidget {
  final Map<String, double> dataMap = new Map();
  final GlobalStats stats;

  GlobalGraph(this.stats) {
    dataMap.putIfAbsent("active", () => stats.active.toDouble());
    dataMap.putIfAbsent("dead", () => stats.deaths.toDouble());
    dataMap.putIfAbsent("ok", () => stats.recovered.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return Column(
      children: <Widget>[
        _buildGraph(context),
        SizedBox(height: 32),
        _statTile(Color(0xffffffff), 'Total Cases',
            stats.cases.toString().replaceAllMapped(reg, mathFunc)),
        _statTile(Color(0xfff5c76a), 'Active',
            stats.active.toString().replaceAllMapped(reg, mathFunc)),
        _statTile(Color(0xffff653b), 'Dead',
            stats.deaths.toString().replaceAllMapped(reg, mathFunc)),
        _statTile(Color(0xff9ff794), 'Recovered',
            stats.recovered.toString().replaceAllMapped(reg, mathFunc)),
      ],
    );
  }

  Widget _buildGraph(BuildContext context) {
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
          title: 'Worldwide',
        ),
      ],
    );
  }

  Widget _statTile(Color color, String label, String value) {
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
              Icon(FeatherIcons.circle,
                  color: color.withOpacity(0.8), size: 10),
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
          Text(
            value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CountryGraph extends StatelessWidget {
  final Map<String, double> dataMap = new Map();
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
        _buildGraph(context),
        SizedBox(height: 32),
        _statTile(
          Color(0xffffffff),
          'Total Cases',
          stats.cases,
        ),
        _statTile(
          Color(0xfff5c76a),
          'Active',
          stats.active,
          plus: stats.todayCases,
        ),
        _statTile(
          Color(0xffff653b),
          'Dead',
          stats.deaths,
          plus: stats.todayDeaths,
        ),
        _statTile(
          Color(0xff9ff794),
          'Recovered',
          stats.recovered,
        )
      ],
    );
  }

  Widget _buildGraph(BuildContext context) {
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
          title: stats.country,
        ),
      ],
    );
  }

  Widget _statTile(Color color, String label, int value, {int plus}) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
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
              Icon(FeatherIcons.circle,
                  color: color.withOpacity(0.8), size: 10),
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
          (plus != null)
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
