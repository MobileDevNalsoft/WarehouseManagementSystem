import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  Future<dynamic> push(String routeName, {Object? arguments}) {
    return navigatorkey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  void popUntil(String routeName) {
    navigatorkey.currentState!.popUntil(
      (route) => route.settings.name == routeName,
    );
  }

  Future<dynamic> popAndPush(String routeName) {
    return navigatorkey.currentState!.popAndPushNamed(routeName);
  }

  void pop() {
    navigatorkey.currentState!.pop();
  }

  Future<dynamic> pushAndRemoveUntil(String routeName, String removeUntilRouteName, {String? arguments}) {
    return navigatorkey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => route.settings.name == removeUntilRouteName, arguments: arguments);
  }

  Future<dynamic> pushReplacement(String routeName, {String? arguments}) {
    return navigatorkey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
}


/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  void push(String routeName, {String? arguments}) {
    final context = navigatorkey.currentState?.context;
    if (context != null) {
      // Then navigate to the new route
      GoRouter.of(context).go(routeName);
    }
  }

  void pushAndRemoveUntil(String routeName, String removeUntilRouteName) {
    // Using GoRouter to navigate
    final context = navigatorkey.currentState?.context;
    if (context != null) {
      // First, pop until we reach the desired route
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // Then navigate to the new route
      GoRouter.of(context).go(routeName);
    }
  }

  void popUntil(String routeName) {
    // Using GoRouter to navigate
    final context = navigatorkey.currentState?.context;
    if (context != null) {
      // First, pop until we reach the desired route
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  void popAndPush(String routeName) {
    // Using GoRouter to navigate
    final context = navigatorkey.currentState?.context;
    if (context != null) {
      Navigator.of(context).pop();
      // Then navigate to the new route
      GoRouter.of(context).go(routeName);
    }
  }

  void pop() {
    navigatorkey.currentState!.pop();
  }

  void pushReplacement(String routeName, {String? arguments}) {
    // Using GoRouter to navigate
    final context = navigatorkey.currentState?.context;
    if (context != null) {
      GoRouter.of(context).pushReplacement(routeName);
    }
  }
}

*/