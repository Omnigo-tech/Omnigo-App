import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/presentation/screens/user_interface/home/home_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';

import '../../data/models/grocery-item.dart';
import '../../presentation/bloc/grocery_details/item_detail_event.dart';
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
        return MaterialPageRoute(
          builder: (_) => LocationScreen(),
        );
      case AppRoutes.phoneInput:
        return MaterialPageRoute(
          builder: (_) => PhoneInputScreen(id: ""),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => HomeBloc()..add(LoadHomeData()),
              ),
              BlocProvider(
                create: (_) => GroceryDetailBloc()..add(LoadItemsEvent()), // ✅ ADD THIS
              ),
            ],
            child: const HomeScreen(),
          ),
        );
      case AppRoutes.myCart:
        return MaterialPageRoute(
          builder: (_) => const MyCartScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("Route Not Found")),
          ),
        );
    }
  }
}