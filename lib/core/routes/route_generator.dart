import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/di/service_locator.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'package:grocery_app/presentation/screens/get_started_screen.dart';
import 'package:grocery_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/call/call_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/chat/chat_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/checkout_summary/checkout_summary_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/tracking/tracking_order_screen.dart';
import 'package:grocery_app/widgets/bottom_navigation_bar.dart';

import '../../presentation/bloc/chat/chat_bloc.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/home/home_event.dart';
import '../../presentation/bloc/tracking/tracking_bloc.dart';
import '../../presentation/bloc/tracking/tracking_event.dart';
import '../../presentation/screens/authentication/location_screen.dart';
import '../../presentation/screens/authentication/login_screen.dart';
import '../../presentation/screens/authentication/otp_screen.dart';
import '../../presentation/screens/authentication/phone_input_screen.dart';
import '../../presentation/screens/authentication/signup_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/user_interface/payment/payment_method_screen.dart';
import '../../presentation/screens/user_interface/review/review_screen.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../enums/otp_purpose.dart';
import 'AppRoutes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.getStarted:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case AppRoutes.otp:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(
            value: "",
            userId: "",
            purpose: OtpPurpose.phoneVerification,
            type: OtpType.phone,
          ),
        );
      case AppRoutes.location:
        return MaterialPageRoute(builder: (_) => const LocationScreen());
      case AppRoutes.phoneInput:
        return MaterialPageRoute(builder: (_) => const PhoneInputScreen());
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
              // Shared GroceryBloc provided here too, so Home screen's
              // CategoriesWidget and the grocery tab both read/write the
              // SAME bloc instance (sl is a lazy singleton).
              BlocProvider.value(value: sl<GroceryBloc>()),
            ],
            child: const AppBottomBar(),
          ),
        );
      case AppRoutes.myCart:
        return MaterialPageRoute(builder: (_) => const MyCartScreen());

      case AppRoutes.groceryhome:
        final category = (settings.arguments is String)
            ? settings.arguments as String
            : '';
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
              // FIX: use BlocProvider.value with the SAME shared
              // GroceryBloc instance (sl<GroceryBloc>()) instead of
              // creating a new one. Dispatch a single LoadGroceryEvent
              // with initialCategory — this removes the race condition
              // where SelectCategoryEvent previously fired immediately
              // after LoadGroceryEvent while the API call was still in
              // flight and allItems was empty.
              BlocProvider.value(value: sl<GroceryBloc>()),
            ],
            child: Builder(
              builder: (context) {
                // Dispatch once when this route builds
                context.read<GroceryBloc>().add(
                  LoadGroceryEvent(initialCategory: category),
                );
                return AppBottomBar(
                  body: GroceryHomeScreen(nameCategories: category),
                );
              },
            ),
          ),
        );
      case AppRoutes.addressdetail:
        final method = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AddressBloc()..add(LoadAddresses())),
            ],
            child: CheckoutSummaryScreen(selectedMethod: method),
          ),
        );
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (_) => ChatBloc(), child: ChatScreen()),
        );

      case AppRoutes.call:
        return MaterialPageRoute(builder: (_) => const CallScreen());

      case AppRoutes.paymentmethodScreen:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());

      case AppRoutes.trackingOrder:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => TrackingBloc()..add(FetchTrackingDetails()),
              ),
            ],
            child: TrackingOrderScreen(),
          ),
        );
      case AppRoutes.review:
        return MaterialPageRoute(builder: (_) => const ReviewScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/di/service_locator.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_event.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'package:grocery_app/presentation/screens/get_started_screen.dart';
import 'package:grocery_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/call/call_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/chat/chat_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/checkout_summary/checkout_summary_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/tracking/tracking_order_screen.dart';
import 'package:grocery_app/widgets/bottom_navigation_bar.dart';

import '../../presentation/bloc/chat/chat_bloc.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/home/home_event.dart';
import '../../presentation/bloc/tracking/tracking_bloc.dart';
import '../../presentation/bloc/tracking/tracking_event.dart';
import '../../presentation/screens/authentication/location_screen.dart';
import '../../presentation/screens/authentication/login_screen.dart';
import '../../presentation/screens/authentication/otp_screen.dart';
import '../../presentation/screens/authentication/phone_input_screen.dart';
import '../../presentation/screens/authentication/signup_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/user_interface/payment/payment_method_screen.dart';
import '../../presentation/screens/user_interface/review/review_screen.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../enums/otp_purpose.dart';
import 'AppRoutes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.getStarted:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case AppRoutes.otp:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(
            value: "",
            userId: "",
            purpose: OtpPurpose.phoneVerification,
            type: OtpType.phone,
          ),
        );
      case AppRoutes.location:
        return MaterialPageRoute(builder: (_) => const LocationScreen());
      case AppRoutes.phoneInput:
        return MaterialPageRoute(builder: (_) => const PhoneInputScreen());
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

      /*case AppRoutes.groceryhome:
        final category = (settings.arguments is String)
            ? settings.arguments as String
            : '';
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
              BlocProvider(
                create: (_) =>
                    sl<GroceryBloc>()
                      ..add(LoadGroceryEvent(initialCategory: category)),
              ),
            ],
            child: AppBottomBar(
              body: GroceryHomeScreen(nameCategories: category),
            ),
          ),
        );*/
      case AppRoutes.groceryhome:
        final category = (settings.arguments is String)
            ? settings.arguments as String
            : '';
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
              BlocProvider(
                create: (_) => sl<GroceryBloc>()
                  ..add(LoadGroceryEvent())
                  ..add(SelectCategoryEvent(category)),
              ),
            ],
            child: AppBottomBar(
              body: GroceryHomeScreen(nameCategories: category),
            ),
          ),
        );
      case AppRoutes.addressdetail:
        final method = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AddressBloc()..add(LoadAddresses())),
            ],
            child: CheckoutSummaryScreen(selectedMethod: method),
          ),
        );
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (_) => ChatBloc(), child: ChatScreen()),
        );

      case AppRoutes.call:
        return MaterialPageRoute(builder: (_) => const CallScreen());

      case AppRoutes.paymentmethodScreen:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());

      case AppRoutes.trackingOrder:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => TrackingBloc()..add(FetchTrackingDetails()),
              ),
            ],
            child: TrackingOrderScreen(),
          ),
        );
      case AppRoutes.review:
        return MaterialPageRoute(builder: (_) => const ReviewScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}*/
