import 'package:flutter/material.dart';
import 'package:wooha/pages/game/game_page.dart';
import 'package:wooha/pages/loading_page/loading_page.dart';
import 'package:wooha/pages/main_menu/main_menu_page.dart';

class AppRouter {
  static Future<dynamic> _fadeInPage(BuildContext context, Widget widget,
      {replacement = false, removeUntil = false, RoutePredicate? predicate, RouteSettings? settings}) async {
    String routeName = DateTime.now().toIso8601String();
    if (replacement) {
      return Navigator.of(context, rootNavigator: true).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, _, __) => widget,
          settings: settings ?? RouteSettings(name: routeName),
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }));
    } else if (removeUntil) {
      return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, _, __) => widget,
            settings: settings ?? RouteSettings(name: routeName),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
          predicate ?? (Route<dynamic> route) => route.isFirst);
    } else {
      return Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
          pageBuilder: (context, _, __) => widget,
          settings: settings ?? RouteSettings(name: routeName),
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }));
    }
  }

  static void openLoadingPage(BuildContext context, {required Future<void> future, required VoidCallback onLoaded}) {
    _fadeInPage(context, LoadingPage(future: future, onLoaded: onLoaded));
  }

  static void openGame(BuildContext context) {
    _fadeInPage(context, const GamePage(), replacement: true);
  }
  static void openMainMenu(BuildContext context) {
    _fadeInPage(context, const MainMenu(), replacement: true);
  }
}
