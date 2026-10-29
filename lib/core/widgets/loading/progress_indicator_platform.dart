import 'package:flutter/material.dart';

class ProgressIndicatorPlatform extends StatelessWidget {
  const ProgressIndicatorPlatform({this.verticalPadding = 30, super.key});
  final double verticalPadding;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: const CircularProgressIndicator.adaptive(),
    ),
  );
}
