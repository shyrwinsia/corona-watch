import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xff35436e), const Color(0xff37607e)]),
          ),
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
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                statTile(FontAwesomeIcons.globe, Colors.white, 'Total Cases',
                    '89,230'),
                SizedBox(
                  height: 8,
                ),
                statTile(FontAwesomeIcons.search, Colors.amberAccent,
                    'Suspected', '52,391'),
                SizedBox(
                  height: 8,
                ),
                statTile(FontAwesomeIcons.check, Colors.orange, 'Confirmed',
                    '29,389'),
                SizedBox(
                  height: 8,
                ),
                statTile(FontAwesomeIcons.skull, Colors.red, 'Deaths', '7,234'),
                SizedBox(
                  height: 8,
                ),
                statTile(FontAwesomeIcons.solidHeart, Colors.green, 'Recovered',
                    '1,345')
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statTile(IconData icon, Color color, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: new BorderRadius.all(new Radius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: color.withOpacity(0.8),
            size: 42,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(fontSize: 42, color: color),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: color.withOpacity(.8)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

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
