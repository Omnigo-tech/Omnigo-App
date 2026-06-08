import 'package:get_it/get_it.dart';
import 'package:grocery_app/data/datasource/repositories/glocery_data.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';

import '../../data/datasource/repositories/auth_repository.dart';
import '../../data/datasource/repositories/location_repository.dart';
import '../../data/datasource/services/location_service.dart';
import '../../presentation/bloc/location/location_bloc.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void setup() {
  // Core / Network
  sl.registerLazySingleton(() => DioClient.getDio());
  sl.registerLazySingleton(() => ApiService(sl()));

  // ================= AUTH FEATURE =================
  sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));

  // ================= LOCATION FEATURE =================
  // 1. Location Service (GPS hardware ke liye)
  sl.registerLazySingleton(() => LocationService());

  // 2. Location Repository (Is mein service inject ho rahi ha)
  sl.registerLazySingleton(() => LocationRepository(sl()));

  // 3. Location Bloc (Factory taake har dafa naya state mile)
  sl.registerFactory<LocationBloc>(() => LocationBloc(sl()));

  // ================= GROCERY FEATURE =================

  sl.registerLazySingleton(() => GroceryRepository(sl()));

  sl.registerFactory<GroceryBloc>(() => GroceryBloc(sl()));
}
