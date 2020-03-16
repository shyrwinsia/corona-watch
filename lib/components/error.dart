import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin ErrorMixin on Widget {
  Widget buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
