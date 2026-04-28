import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/presentation/screens/user_interface/checkout_summary/checkout_summary_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/home/home_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/payment_method_screen.dart';
import 'package:grocery_app/widgets/bottom_navigation_bar.dart';

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
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case AppRoutes.otp:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(phone: "", userId: ""),
        );
      case AppRoutes.location:
        return MaterialPageRoute(builder: (_) => const LocationScreen());
      case AppRoutes.phoneInput:
        return MaterialPageRoute(
          builder: (_) => const PhoneInputScreen(id: ""),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
            ],
            child: const AppBottomBar(),
          ),
        );
      case AppRoutes.myCart:
        return MaterialPageRoute(builder: (_) => const MyCartScreen());

      case AppRoutes.groceryhome:
        final category = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => GroceryBloc()..add(LoadGroceryEvent())
                ..add(SelectCategoryEvent(category))
              ),
            ],
            child: AppBottomBar(
              body: GroceryHomeScreen(nameCategories: category),
            ),
          ),
        );
      case AppRoutes.addressdetail:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AddressBloc()..add(LoadAddresses())),
            ],
            child: const CheckoutSummaryScreen(),
          ),
        );
      case AppRoutes.paymentmethodScreen:
        return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}
