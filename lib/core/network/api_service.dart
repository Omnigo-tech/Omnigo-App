import 'package:dio/dio.dart';
import 'package:grocery_app/data/models/user_model.dart';
import 'package:grocery_app/data/models/wishlist_toggle_response_model.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/favourite_response_model.dart';
import '../../data/models/google_login_response_model.dart';
import '../../data/models/onboarding_model.dart';
import '../../data/models/onboarding_response_model.dart';


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

  @POST("auth/google-login")
  Future<GoogleLoginResponse> googleLogin(
      @Body() Map<String, dynamic> body,
      );


  @POST("facebook-login")
  Future<UserModel> facebookLogin(
      @Body() Map<String, dynamic> body,
      );

  @GET("auth/location/zones")
  Future<dynamic> getZones();

  @POST("auth/location/manual")
  Future<dynamic> saveManualLocation(
      @Body() Map<String, dynamic> body,
      );

  @POST("auth/location/auto")
  Future<dynamic> saveAutoLocation(
      @Body() Map<String, dynamic> body,
      );

  @GET("onboarding")
  Future<OnboardingResponseModel> getOnboardingData();

  @POST("wishlist/toggle")
  Future<WishlistToggleResponseModel> toggleWishlist(
      @Body() Map<String, dynamic> body,
      );

  @GET("wishlist")
  Future<FavoriteResponse> getFavorites();

  @GET("products")
  Future<List<GroceryModel>> getProducts(
      @Query("category") String? category,
      @Query("q") String? search,
      );
}
