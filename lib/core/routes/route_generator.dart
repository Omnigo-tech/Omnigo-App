import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/home_screen.dart';

import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/home/home_event.dart';
import '../../presentation/screens/authentication/location_screen.dart';
import '../../presentation/screens/authentication/login_screen.dart';
import '../../presentation/screens/authentication/otp_screen.dart';
import '../../presentation/screens/authentication/phone_input_screen.dart';
import '../../presentation/screens/authentication/signup_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import 'AppRoutes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case AppRoutes.otp:
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phone: "", userId: ""),
        );
      case AppRoutes.location:
        return MaterialPageRoute(builder: (_) => LocationScreen());
      case AppRoutes.phoneInput:
        return MaterialPageRoute(builder: (_) => PhoneInputScreen(id: ""));
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HomeBloc()..add(LoadHomeData()),
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.groceryhome:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GroceryBloc()..add(LoadGroceryEvent()),
            child: const GroceryView(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}
