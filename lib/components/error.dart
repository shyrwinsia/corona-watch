import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin ErrorMixin on Widget {
  Widget buildError({String cause, String action}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FeatherIcons.alertCircle,
            size: 48,
            color: Color(0xffff653b),
          ),
          SizedBox(height: 12),
          Text(
            cause,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          Text(
            action,
            style:
                TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
