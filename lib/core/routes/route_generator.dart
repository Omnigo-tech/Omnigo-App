import 'package:flutter/material.dart';
import 'package:grocery_app/data/datasource/repositories/fast_food_home_repository.dart';
import 'package:grocery_app/presentation/bloc/fast_foods/fast_food_home_bloc.dart';
import 'package:grocery_app/presentation/fastfoodscreens/home/restaurant_detail_screen.dart';
import 'package:grocery_app/widgets/categories_widget.dart'
    show GroceryHomeArgs;
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

import '../../data/datasource/remote/socket_service.dart';
import '../../data/datasource/repositories/address_repository.dart';
import '../../data/models/fast_foods_models/restaurant_model.dart';
import '../../data/datasource/repositories/chat_repository.dart';
import '../../presentation/bloc/chat/chat_bloc.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/home/home_event.dart';
import '../../presentation/bloc/profile/profile_bloc.dart';
import '../../presentation/bloc/tracking/tracking_bloc.dart';
import '../../presentation/bloc/tracking/tracking_event.dart';
import '../../presentation/fastfoodscreens/home/fast_food_home_screen.dart';
import '../../presentation/screens/authentication/location_screen.dart';
import '../../presentation/screens/authentication/login_screen.dart';
import '../../presentation/screens/authentication/otp_screen.dart';
import '../../presentation/screens/authentication/phone_input_screen.dart';
import '../../presentation/screens/authentication/signup_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/user_interface/  profile/profile_screen.dart';
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
        String? category;
        bool showAll = false;

        if (settings.arguments is GroceryHomeArgs) {
          final args = settings.arguments as GroceryHomeArgs;
          category = args.category;
          showAll = args.showAll;
        } else if (settings.arguments is String) {
          category = settings.arguments as String;
        }

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
              BlocProvider.value(value: sl<GroceryBloc>()),
            ],
            child: Builder(
              builder: (context) {
                context.read<GroceryBloc>().add(
                  LoadGroceryEvent(initialCategory: category, showAll: showAll),
                );
                return AppBottomBar(
                  body: GroceryHomeScreen(nameCategories: category ?? ''),
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
              BlocProvider(
                create: (_) =>
                    AddressBloc(sl<AddressRepository>())..add(LoadAddresses()),
              ),
            ],
            child: CheckoutSummaryScreen(selectedMethod: method),
          ),
        );
      case AppRoutes.chat:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => ChatBloc(sl<ChatRepository>(), sl<SocketService>()),
            child: ChatScreen(),
          ),
        );

      case AppRoutes.call:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CallScreen(),
        );

      case AppRoutes.paymentmethodScreen:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());

      case AppRoutes.trackingOrder:
        final args = settings.arguments as Map<String, dynamic>;
        final String orderId = args['orderId']?.toString() ?? '';
        final String userId = args['userId']?.toString() ?? '';

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                // sl() hamare GetIt service locator se TrackingBloc ke dependencies (repository + socket) auto inject kar dega
                create: (_) => sl<TrackingBloc>(),
              ),
            ],
            child: TrackingOrderScreen(orderId: orderId, userId: userId),
          ),
        );
      case AppRoutes.review:
        return MaterialPageRoute(builder: (_) => const ReviewScreen());

      case AppRoutes.fastFoodHome:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FastFoodHomeBloc(sl<FastFoodHomeRepository>()),
            child: FastFoodHomeScreen(),
          ),
        );
      case AppRoutes.restaurantScreen:
        final restaurantId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RestaurantDetailScreen(restaurantId: restaurantId),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProfileBloc>(),
            child: const ProfileScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}
