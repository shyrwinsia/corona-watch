import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Flags {
  static Widget get(String country) {
    country = country.replaceAll(RegExp("[^A-Za-z]"), '').toLowerCase();
    Widget svg = SvgPicture.asset(
      'img/flags/$country.svg',
      height: 10,
    );
    return svg;
  }
}
