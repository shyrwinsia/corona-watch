import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Flags {
  static Widget get(String code) {
    if (code != null)
      return SvgPicture.asset(
        'flags/$code.svg',
        height: 10,
      );
    else
      return SvgPicture.asset(
        'flags/XX.svg',
        height: 10,
      );
  }
}
