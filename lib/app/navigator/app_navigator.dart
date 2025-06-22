import 'package:flutter/material.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  Future<T?> push<T extends Object?>(Route<T> route) {
    return navigator.currentState?.push(route) ?? Future.value(null);
  }

  Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return navigator.currentState?.pushNamed(routeName, arguments: arguments) ??
        Future.value(null);
  }

  void pop<T extends Object?>([T? result]) {
    navigator.currentState?.pop(result);
  }

  bool canPop() {
    return navigator.currentState?.canPop() ?? false;
  }

  void popUntil(RoutePredicate predicate) {
    navigator.currentState?.popUntil(predicate);
  }

  //

  void popAndPushNamed(String routeName, {Object? arguments}) {
    navigator.currentState?.popAndPushNamed(routeName, arguments: arguments);
  }

  void pushReplacementNamed(String routeName, {Object? arguments}) {
    navigator.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  void pushNamedAndRemoveUntil(String routeName, RoutePredicate predicate,
      {Object? arguments}) {
    navigator.currentState
        ?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pushReplacement(Route<dynamic> route) {
    navigator.currentState?.pushReplacement(route);
  }

  void pushNamedAndRemoveUntilWithReplacement(
      String routeName, RoutePredicate predicate,
      {Object? arguments}) {
    navigator.currentState
        ?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pushNamedWithReplacement(String routeName, {Object? arguments}) {
    navigator.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  void pushNamedWithArguments(String routeName, {Object? arguments}) {
    navigator.currentState?.pushNamed(routeName, arguments: arguments);
  }

  void pushNamedWithArgumentsAndRemoveUntil(
      String routeName, RoutePredicate predicate,
      {Object? arguments}) {
    navigator.currentState
        ?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pushNamedWithReplacementAndArguments(String routeName,
      {Object? arguments}) {
    navigator.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  void pushNamedWithReplacementAndArgumentsAndRemoveUntil(
      String routeName, RoutePredicate predicate,
      {Object? arguments}) {
    navigator.currentState
        ?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pushNamedWithArgumentsAndReplacement(String routeName,
      {Object? arguments}) {
    navigator.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  void pushNamedWithArgumentsAndReplacementAndRemoveUntil(
      String routeName, RoutePredicate predicate,
      {Object? arguments}) {
    navigator.currentState
        ?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }
}
