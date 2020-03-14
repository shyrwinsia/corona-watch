import 'dart:async';

import 'package:covidwatch/api.dart';
import 'package:covidwatch/countrydetail.dart';
import 'package:covidwatch/model.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class CountriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final StreamController<CountryList> stats = StreamController();
  List<CountryStats> current = List();

  @override
  void initState() {
    super.initState();
    _fetch();
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
            onPressed: () {
              current.sort((a, b) => a.country.compareTo(b.country));
              stats.add(CountryList(list: current));
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder<CountryList>(
          stream: stats.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              this.current = snapshot.data.list;
              return ListView.separated(
                  itemCount: snapshot.data.list.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: Colors.white24),
                  itemBuilder: (BuildContext context, int index) =>
                      _buildTile(snapshot.data.list[index]));
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Fetching latest updates',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Source: worldometers.info',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(.6)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTile(CountryStats stats) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountryDetailPage(countryStats: stats),
        ),
      ),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          stats.cases
                              .toString()
                              .replaceAllMapped(reg, mathFunc),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          "Total Cases",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              stats.active
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(width: 1),
                            Text(
                              "+${stats.todayCases.toString().replaceAllMapped(reg, mathFunc)}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              stats.deaths
                                  .toString()
                                  .replaceAllMapped(reg, mathFunc),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(width: 1),
                            Text(
                              "+${stats.todayDeaths.toString().replaceAllMapped(reg, mathFunc)}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
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
                  ])
            ],
          )),
    );
  }

  void _fetch() async {
    stats.add(null);
    await RestApi.fetchCountries().catchError((onError) {
      print('Some error occured');
      stats.addError(onError);
    }).then((countryStats) => stats.add(countryStats));
  }

  @override
  void dispose() {
    stats.close();
    super.dispose();
  }
}
