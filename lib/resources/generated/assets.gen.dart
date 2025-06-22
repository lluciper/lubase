/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class Assets {
  const Assets._();

  /// File path: assets/fonts/SF-Pro-Text-Black.otf
  static const String fontsSFProTextBlack =
      'assets/fonts/SF-Pro-Text-Black.otf';

  /// File path: assets/fonts/SF-Pro-Text-Bold.otf
  static const String fontsSFProTextBold = 'assets/fonts/SF-Pro-Text-Bold.otf';

  /// File path: assets/fonts/SF-Pro-Text-Heavy.otf
  static const String fontsSFProTextHeavy =
      'assets/fonts/SF-Pro-Text-Heavy.otf';

  /// File path: assets/fonts/SF-Pro-Text-Light.otf
  static const String fontsSFProTextLight =
      'assets/fonts/SF-Pro-Text-Light.otf';

  /// File path: assets/fonts/SF-Pro-Text-Medium.otf
  static const String fontsSFProTextMedium =
      'assets/fonts/SF-Pro-Text-Medium.otf';

  /// File path: assets/fonts/SF-Pro-Text-Regular.otf
  static const String fontsSFProTextRegular =
      'assets/fonts/SF-Pro-Text-Regular.otf';

  /// File path: assets/fonts/SF-Pro-Text-Semibold.otf
  static const String fontsSFProTextSemibold =
      'assets/fonts/SF-Pro-Text-Semibold.otf';

  /// File path: assets/fonts/SF-Pro-Text-Thin.otf
  static const String fontsSFProTextThin = 'assets/fonts/SF-Pro-Text-Thin.otf';

  /// File path: assets/fonts/SF-Pro-Text-Ultralight.otf
  static const String fontsSFProTextUltralight =
      'assets/fonts/SF-Pro-Text-Ultralight.otf';

  /// File path: assets/icons/back.svg
  static const SvgGenImage iconsBack = SvgGenImage('assets/icons/back.svg');

  /// File path: assets/icons/close.svg
  static const SvgGenImage iconsClose = SvgGenImage('assets/icons/close.svg');

  /// File path: assets/icons/log_out.svg
  static const SvgGenImage iconsLogOut = SvgGenImage(
    'assets/icons/log_out.svg',
  );

  /// List of all assets
  static List<dynamic> get values => [
    fontsSFProTextBlack,
    fontsSFProTextBold,
    fontsSFProTextHeavy,
    fontsSFProTextLight,
    fontsSFProTextMedium,
    fontsSFProTextRegular,
    fontsSFProTextSemibold,
    fontsSFProTextThin,
    fontsSFProTextUltralight,
    iconsBack,
    iconsClose,
    iconsLogOut,
  ];
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
