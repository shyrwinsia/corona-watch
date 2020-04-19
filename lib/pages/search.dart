import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF222222),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 16),
                  onChanged: (text) {
                    // send this to the bloc as event for processing
                  },
                  cursorColor: Color(0xff8fa7f4),
                  decoration: InputDecoration(
                    fillColor: Color(0xff8fa7f4),
                    focusColor: Color(0xff8fa7f4),
                    hoverColor: Color(0xff8fa7f4),
                    hintText: 'Enter country or territory',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(fontSize: 16),
                    icon: Icon(
                      FeatherIcons.search,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
