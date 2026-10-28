import 'package:flutter/material.dart';

part 'app_colors.dart';

extension BuildContextResource on BuildContext {
  ColorsDefine get colors {
    switch (Theme.of(this).brightness) {
      case Brightness.light:
        return ColorsDefine.colorsLight;
      case Brightness.dark:
        return ColorsDefine.colorsDark;
    }
  }
}
