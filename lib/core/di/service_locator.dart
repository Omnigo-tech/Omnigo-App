import 'package:get_it/get_it.dart';
import 'package:grocery_app/data/datasource/repositories/glocery_data.dart';
import 'package:grocery_app/data/datasource/repositories/wishlist_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasource/local/auth_local_data_source.dart';
import '../../data/datasource/repositories/auth_repository.dart';
import '../../data/datasource/repositories/location_repository.dart';
import '../../data/datasource/repositories/onboarding_repository.dart';
import '../../data/datasource/services/location_service.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/grocery_details/item_detail_bloc.dart';
import '../../presentation/bloc/location/location_bloc.dart';
import '../../presentation/bloc/onboarding/onboarding_bloc.dart';
import '../../presentation/grocery/grocery_bloc/grocery_bloc.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setup() async {

  // ================= SHARED PREF =================
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ================= LOCAL DATA =================
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSource(sl()),
  );

  // ================= CORE =================
  sl.registerLazySingleton<DioClient>(
        () => DioClient(sl()),
  );

  sl.registerLazySingleton(() => sl<DioClient>().getDio());

  sl.registerLazySingleton<ApiService>(
        () => ApiService(sl()),
  );

  // ================= SERVICES =================
  sl.registerLazySingleton(() => LocationService());

  // ================= REPOSITORIES =================
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepository(
      sl(),
      sl(),
    ),
  );

  sl.registerLazySingleton<LocationRepository>(
        () => LocationRepository(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepository(sl()));
  sl.registerLazySingleton<GroceryRepository>(() => GroceryRepository(sl()));
  sl.registerLazySingleton<WishlistRepository>(() => WishlistRepository(sl()));

  // ================= BLOCS =================
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(sl()),
  );

  sl.registerFactory<LocationBloc>(
        () => LocationBloc(sl()),
  );
  sl.registerFactory(() => GroceryBloc(sl()));
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc(sl()));

  sl.registerFactory<GroceryDetailBloc>(
        () => GroceryDetailBloc(
      sl<WishlistRepository>(),
    ),


  );


}