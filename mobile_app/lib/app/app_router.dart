import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/features/splash/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../core/data_store/navigation_store.dart';
import '../features/dashboard/dashboard_screen.dart';

class AppRouter with NavigationStore {
  final Map<String, Widget Function()> _fadeAnimatedRoutes = {DashboardScreen.routeName: () => const DashboardScreen()};

  final Map<String, Widget Function()> _platformRoutes = {};

  PageTransition routeAnimation(Function widgetBuilder,
      {PageTransitionType animationType = PageTransitionType.fade,
      Duration duration = const Duration(milliseconds: 200),
      String routeName = ''}) {
    return PageTransition(
        settings: RouteSettings(name: routeName),
        child: widgetBuilder(),
        type: animationType,
        duration: duration,
        reverseDuration: duration);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (_fadeAnimatedRoutes.containsKey(settings.name)) {
      return routeAnimation(_fadeAnimatedRoutes[settings.name]!,
          routeName: settings.name!,
          animationType: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200));
    }

    if (_platformRoutes.containsKey(settings.name)) {
      final screenBuilder = _platformRoutes[settings.name];
      return Platform.isIOS
          ? CupertinoPageRoute(builder: (_) => screenBuilder!())
          : MaterialPageRoute(builder: (_) => screenBuilder!());
    }

    return null;
  }

  String get initialRouteName => SplashScreen.routeName;

  Map<String, WidgetBuilder> get initialRoute => {
        SplashScreen.routeName: (_) => const SplashScreen(),
      };
}
