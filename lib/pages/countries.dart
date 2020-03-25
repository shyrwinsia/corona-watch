import 'package:covidwatch/components/countrydetail.dart';
import 'package:covidwatch/components/sort.dart';
import 'package:covidwatch/data/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../components/flag.dart';

class CountriesPage extends StatefulWidget {
  final CountryList stats;

  CountriesPage(this.stats);
  @override
  State<StatefulWidget> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  List<CountryStats> _current;

  SortBy _sortBy = SortBy.alphabetical;
  OrderBy _orderBy = OrderBy.desc;

  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
    this._current = widget.stats.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "COUNTRIES AND TERRITORIES",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            child: Text('Sort'),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => SortbyDialog(
                list: _current,
                sortBy: _sortBy,
                orderBy: _orderBy,
                stateSetter: (SortBy sortBy, OrderBy orderBy,
                        List<CountryStats> stats) =>
                    setState(
                  () {
                    _sortBy = sortBy;
                    _orderBy = orderBy;
                    _current = stats;
                    _scroller.animateTo(
                      0.0,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 1),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
            controller: _scroller,
            itemCount: _current.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.white38),
            itemBuilder: (BuildContext context, int index) =>
                _buildTile(_current[index])),
      ),
    );
  }

  Widget _buildTile(CountryStats stats) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountryDetailPage(countryStats: stats),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flags.get(stats.country),
                SizedBox(
                  width: 5,
                ),
                Text(
                  stats.country,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _buildStats(stats),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStats(CountryStats stats) {
    switch (_sortBy) {
      case SortBy.total:
      case SortBy.alphabetical:
        return [
          _buildStat(
              'Total Cases', stats.cases, 0, Colors.white.withOpacity(0.8)),
          _buildStat('Active', stats.active, stats.todayCases,
              Color(0xfff5c76a).withOpacity(0.8)),
          _buildStat('Deaths', stats.deaths, stats.todayDeaths,
              Color(0xffff653b).withOpacity(0.8)),
          _buildStat('Recovered', stats.recovered, 0,
              Color(0xff9ff794).withOpacity(0.8)),
        ];
      case SortBy.active:
      case SortBy.todayActive:
        return [
          _buildStat('Active', stats.active, stats.todayCases,
              Color(0xfff5c76a).withOpacity(0.8)),
          _buildStat('Deaths', stats.deaths, stats.todayDeaths,
              Color(0xffff653b).withOpacity(0.8)),
          _buildStat('Recovered', stats.recovered, 0,
              Color(0xff9ff794).withOpacity(0.8)),
          _buildStat(
              'Total Cases', stats.cases, 0, Colors.white.withOpacity(0.8)),
        ];
      case SortBy.deaths:
      case SortBy.todayDeaths:
        return [
          _buildStat('Deaths', stats.deaths, stats.todayDeaths,
              Color(0xffff653b).withOpacity(0.8)),
          _buildStat('Recovered', stats.recovered, 0,
              Color(0xff9ff794).withOpacity(0.8)),
          _buildStat('Active', stats.active, stats.todayCases,
              Color(0xfff5c76a).withOpacity(0.8)),
          _buildStat(
              'Total Cases', stats.cases, 0, Colors.white.withOpacity(0.8)),
        ];
      case SortBy.recovered:
        return [
          _buildStat('Recovered', stats.recovered, 0,
              Color(0xff9ff794).withOpacity(0.8)),
          _buildStat('Active', stats.active, stats.todayCases,
              Color(0xfff5c76a).withOpacity(0.8)),
          _buildStat('Deaths', stats.deaths, stats.todayDeaths,
              Color(0xffff653b).withOpacity(0.8)),
          _buildStat(
              'Total Cases', stats.cases, 0, Colors.white.withOpacity(0.8)),
        ];
      default:
        return [];
    }
  }

  Widget _buildStat(String label, int base, int increase, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (increase != 0)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    _convert(base),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    FeatherIcons.arrowUp,
                    size: 10,
                  ),
                  Text(
                    "${_convert(increase)}",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              )
            : Text(
                _convert(base),
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: color),
        ),
      ],
    );
  }

  String _convert(int num) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return num.toString().replaceAllMapped(reg, mathFunc);
  }

  @override
  void dispose() {
    super.dispose();
    _scroller.dispose();
  }
}
