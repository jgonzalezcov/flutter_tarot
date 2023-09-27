import 'package:flutter/material.dart';
import 'package:tarot/src/screens/screens.dart' as screens;

class AppRoutes {
  static const initialRouter = 'home';

  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (context) => const screens.HomeScreen(),
    'table': (context) => const screens.TableScreen(),
    'select': (context) => const screens.SelectCard(),
    'shake': (context) => const screens.ShakeScreen(),
  };
}
