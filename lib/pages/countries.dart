import 'package:covidwatch/components/countrydetail.dart';
import 'package:covidwatch/components/sort.dart';
import 'package:covidwatch/data/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class CountriesPage extends StatefulWidget {
  final CountryList stats;

  CountriesPage(this.stats);
  @override
  State<StatefulWidget> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  List<CountryStats> _current;

  SortBy _sortBy = SortBy.total;
  OrderBy _orderBy = OrderBy.desc;

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
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "COUNTRIES",
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
            itemCount: _current.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.white38),
            itemBuilder: (BuildContext context, int index) =>
                _buildTile(_current[index])),
      ),
    );
  }

  Widget _buildTile(CountryStats stats) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

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
            Text(
              stats.country,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      stats.cases.toString().replaceAllMapped(reg, mathFunc),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "Total Cases",
                      style: TextStyle(
                          fontSize: 10, color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (stats.todayCases != 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                stats.active
                                    .toString()
                                    .replaceAllMapped(reg, mathFunc),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                FeatherIcons.arrowUp,
                                size: 10,
                              ),
                              Text(
                                "${stats.todayCases.toString().replaceAllMapped(reg, mathFunc)}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )
                        : Text(
                            stats.active
                                .toString()
                                .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    Text(
                      "Active",
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xfff5c76a).withOpacity(0.8)),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (stats.todayDeaths != 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                stats.deaths
                                    .toString()
                                    .replaceAllMapped(reg, mathFunc),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                FeatherIcons.arrowUp,
                                size: 10,
                              ),
                              Text(
                                "${stats.todayDeaths.toString().replaceAllMapped(reg, mathFunc)}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )
                        : Text(
                            stats.deaths
                                .toString()
                                .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    Text(
                      "Deaths",
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xffff653b).withOpacity(0.8)),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      stats.recovered
                          .toString()
                          .replaceAllMapped(reg, mathFunc),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "Recovered",
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xff9ff794).withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
