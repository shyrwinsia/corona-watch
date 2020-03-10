import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chart/pie_chart.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arimo',
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, double> dataMap = new Map();

  _MyHomePageState() {
    dataMap.putIfAbsent("suspect", () => 56391);
    dataMap.putIfAbsent("sick", () => 29389);
    dataMap.putIfAbsent("dead", () => 4234);
    dataMap.putIfAbsent("ok", () => 1345);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.black),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "COVID-19 STATISTICS",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    FeatherIcons.filter,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {})
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartRadius: MediaQuery.of(context).size.width / 1.4,
                      showChartValuesInPercentage: true,
                      showChartValues: false,
                      showChartValuesOutside: true,
                      colorList: [
                        Color(0xff8fa7f4),
                        Color(0xfff5c76a),
                        Color(0xffff653b),
                        Color(0xff9ff794)
                      ],
                      showLegends: false,
                      decimalPlaces: 1,
                      showChartValueLabel: true,
                      initialAngle: 0.5,
                      chartType: ChartType.ring,
                      chartValueStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      title: 'Worldwide',
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    statTile(const Color(0xff18dcf8), 'Total Cases', '89,230'),
                    SizedBox(
                      height: 8,
                    ),
                    statTile(const Color(0xff8fa7f4), 'Suspected', '56,391'),
                    SizedBox(
                      height: 8,
                    ),
                    statTile(const Color(0xfff5c76a), 'Confirmed', '29,389'),
                    SizedBox(
                      height: 8,
                    ),
                    statTile(const Color(0xffff653b), 'Deaths', '4,234'),
                    SizedBox(
                      height: 8,
                    ),
                    statTile(const Color(0xff9ff794), 'Recovered', '1,345'),
                  ],
                ),
                Text(
                  'Last fetched 4 minutes ago',
                  style: TextStyle(
                      fontSize: 10, color: Colors.white.withOpacity(.4)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statTile(Color color, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white10),
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
                    fontSize: 14, color: Colors.white.withOpacity(.6)),
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

// Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   crossAxisAlignment: CrossAxisAlignment.end,
//   children: <Widget>[
//     Text(
//       value,
//       style: TextStyle(fontSize: 42, color: color),
//     ),
//     SizedBox(
//       height: 2,
//     ),
//     Text(
//       label,
//       style: TextStyle(fontSize: 12, color: color.withOpacity(.8)),
//     )
//   ],
// ),
// Column(
//   children: <Widget>[
//     SizedBox(
//       height: 14,
//     ),
//     Text(
//       label,
//       style: Theme.of(context).textTheme.body2,
//     )
//   ],
// ),
//  decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x22FFB74D),
//               blurRadius: 8.0,
//               spreadRadius: 0.0,
//               offset: Offset(
//                 0.0,
//                 3.0,
//               ),
//             ),
//           ],
//         ),
