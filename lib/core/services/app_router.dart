import 'package:flutter/material.dart';
import '../routes/route_generator.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return RouteGenerator.generateRoute(settings);
  }
}