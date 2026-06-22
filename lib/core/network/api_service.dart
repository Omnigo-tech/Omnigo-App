import 'package:dio/dio.dart';
import 'package:grocery_app/data/models/user_model.dart';
import 'package:grocery_app/data/models/wishlist_toggle_response_model.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/address_response_model.dart';
import '../../data/models/cart_response_model.dart';
import '../../data/models/favourite_response_model.dart';
import '../../data/models/google_login_response_model.dart';
import '../../data/models/my_orders_response_model.dart';
import '../../data/models/onboarding_model.dart';
import '../../data/models/onboarding_response_model.dart';
import '../../data/models/order_detail_response_model.dart';
import '../../data/models/place_order_response_model.dart';
import '../../data/models/remove_favourite_response_model.dart';


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

  @DELETE("wishlist/remove/{productId}")
  Future<RemoveFavouriteResponseModel> removeFavorite(
      @Path("productId") String productId,
      );

  @GET("products")
  Future<List<GroceryModel>> getProducts(
      @Query("category") String? category,
      @Query("q") String? search,
      );

  @GET("cart")
  Future<CartResponseModel> getCartItem();


  @POST("cart/add")
  Future<CartResponseModel> addToCart(
      @Body() Map<String, dynamic> body,
      );

  @DELETE("cart/remove/{productId}")
  Future<CartResponseModel> removeToCart(
      @Path("productId") String productId,
      );

  @PUT("cart/update")
  Future<CartResponseModel> updateCart(
      @Body() Map<String, dynamic> body,
      );

  @POST("auth/address")
  Future<AddressResponseModel> addAddress(
      @Body() Map<String, dynamic> body,
      );

  @GET("auth/address")
  Future<AddressResponseModel> getAddresses();

  @PUT("auth/address/{id}")
  Future<AddressResponseModel> updateAddress(
      @Path("id") String id,
      @Body() Map<String, dynamic> body,
      );

  @DELETE("auth/address/{id}")
  Future<AddressResponseModel> deleteAddress(
      @Path("id") String id,
      );

  @POST("orders/create")
  Future<PlaceOrderResponseModel> placeOrder(
      @Body() Map<String, dynamic> body,
      );

  @GET("orders/my-orders")
  Future<MyOrdersResponseModel> getMyOrders();

  @PUT("orders/cancel/{id}")
  Future<MyOrdersResponseModel> cancelOrder(
      @Path("id") String id,
      );

  @GET("orders/details/{id}")
  Future<OrderDetailResponseModel> getOrderDetails(
      @Path("id") String orderId,
      );

  @POST("orders/reorder/{id}")
  Future<MyOrdersResponseModel> reorderOrder(
      @Path("id") String orderId,
      );

}
