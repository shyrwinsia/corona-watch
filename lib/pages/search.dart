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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FeatherIcons.chevronLeft),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                          color: Color(0xFF333333),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          )),
                      child: TextField(
                        style: TextStyle(fontSize: 16),
                        autofocus: true,
                        onChanged: (text) {
                          // send this to the bloc as event for processing
                        },
                        cursorColor: Color(0xff8fa7f4),
                        decoration: InputDecoration(
                          fillColor: Color(0xff8fa7f4),
                          focusColor: Color(0xff8fa7f4),
                          hoverColor: Color(0xff8fa7f4),
                          hintText: 'Search country or territory',
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
