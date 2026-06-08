import 'package:dio/dio.dart';
import 'package:grocery_app/data/models/user_model.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("auth/signup")
  Future<UserModel> signup(@Body() Map<String, dynamic> body);

  @POST("auth/login")
  Future<UserModel> login(@Body() Map<String, dynamic> body);

  @POST("auth/send-otp")
  Future<dynamic> sendOtp(@Body() Map<String, dynamic> body);

  @POST("auth/verify-otp")
  Future<dynamic> verifyOtp(@Body() Map<String, dynamic> body);

  @POST("auth/forgot-password")
  Future<dynamic> forgotPassword(@Body() Map<String, dynamic> body);

  @POST("auth/reset-password")
  Future<dynamic> resetPassword(@Body() Map<String, dynamic> body);

  @POST("google-login")
  Future<UserModel> googleLogin(@Body() Map<String, dynamic> body);

  @POST("facebook-login")
  Future<UserModel> facebookLogin(@Body() Map<String, dynamic> body);

  @GET("products")
  Future<List<GroceryModel>> getProducts(
    @Query("category") String? category,
    @Query("q") String? search,
  );
}
