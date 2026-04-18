import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helper/constants/dimensions-resource.dart';
import 'core/helper/utils/svg-utils.dart';
import 'core/routes/AppRoutes.dart';
import 'core/services/app_router.dart';

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
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
  }

