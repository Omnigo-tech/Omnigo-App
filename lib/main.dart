import 'dart:io'; // <-- Added for HttpOverrides
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_app/core/helper/constants/theme/app_theme.dart';
import 'package:grocery_app/data/datasource/repositories/glocery_data.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:grocery_app/presentation/bloc/call/call_bloc.dart';
import 'package:grocery_app/presentation/bloc/location/location_bloc.dart';
import 'package:grocery_app/presentation/bloc/payment/payment_bloc.dart';
import 'package:grocery_app/presentation/bloc/review/review_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/widgets/global_effect_listener.dart';
import 'core/di/service_locator.dart';
import 'core/helper/constants/dimensions-resource.dart';
import 'core/helper/utils/svg-utils.dart';
import 'core/routes/AppRoutes.dart';
import 'core/services/app_router.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';

import 'core/services/notifications_services.dart';
import 'data/datasource/remote/socket_service.dart';
import 'data/datasource/repositories/address_repository.dart';
import 'data/datasource/repositories/address_repository.dart';

// SSL Handshake Error Fix Class
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SSL Handshake Error Fix Applied Here
  HttpOverrides.global = MyHttpOverrides();

  setup();
  await Firebase.initializeApp();
  print("Project: ${Firebase.app().options.projectId}");
  print("AppId: ${Firebase.app().options.appId}");
  await NotificationService.init();
  await NotificationService.getToken();

  try {
    await NotificationService.init();
    await NotificationService.getToken();
  } catch (e) {
    print("Notification init failed (non-fatal): $e");
  }

  // Screen orientation and basic UI mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SvgUtils.preCacheSVGs();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<GroceryDetailBloc>()..add(LoadItemsEvent()),
        ),
        BlocProvider(
          create: (_) =>
          AddressBloc(sl<AddressRepository>())..add(LoadAddresses()),
        ),
        BlocProvider(create: (context) => CallBloc(sl<SocketService>())),
        BlocProvider(create: (_) => sl<ReviewBloc>()),
        BlocProvider(create: (_) => PaymentBloc()),
        BlocProvider(create: (_) => GroceryBloc(sl<GroceryRepository>())),
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<LocationBloc>(create: (_) => sl<LocationBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        DimensionsResources.D_375,
        DimensionsResources.D_812,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
            builder: (context, widget) {
              return GlobalEffectListener(
                child:
                MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: widget!,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
