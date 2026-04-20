import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'core/helper/constants/dimensions-resource.dart';
import 'core/helper/utils/svg-utils.dart';
import 'core/routes/AppRoutes.dart';
import 'core/services/app_router.dart';

/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroceryBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GroceryHomeScreen(),
      ),
    );
  }
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SvgUtils.preCacheSVGs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(DimensionsResources.D_375, DimensionsResources.D_812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRouter.onGenerateRoute,

          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
