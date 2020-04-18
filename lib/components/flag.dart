import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Flags {
  static Widget get(String code, {double height = 12}) {
    if (code != null)
      return SvgPicture.asset(
        'flags/$code.svg',
        height: height,
      );
    else
      return SvgPicture.asset(
        'flags/XX.svg',
        height: height,
      );
  }
}
