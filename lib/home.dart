import 'package:corona_watch/api.dart';
import 'package:corona_watch/model.dart';
import 'package:corona_watch/graph.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Stats> statsFuture;

  @override
  void initState() {
    super.initState();
    statsFuture = RestApi.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "COVID-19 STATISTICS",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Stats>(
          future: statsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildGlobalStats(snapshot.data.globalStats);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Fetching data',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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

  Widget buildGlobalStats(GlobalStats stats) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Graph(stats),
        FlatButton(
          child:
              Text('See Countries', style: TextStyle(color: Color(0xff8fa7f4))),
          onPressed: () {},
        ),
        Text(
          'Last fetched 4 minutes ago',
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(.6)),
        ),
      ],
    );
  }
}

// TODO
// [x] change circular progress color
// [x] change refresh to button
// [ ] make the manual refresh work
// [ ] error for no connection
// [x] prevent landscape
// [x] make private function
// [ ] add last fetch
// [ ] add fuzzy time
// [ ] add countries
