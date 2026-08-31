import 'package:dio/dio.dart';
import 'package:grocery_app/data/models/user_model.dart';
import 'package:grocery_app/data/models/wishlist_toggle_response_model.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/address_response_model.dart';
import '../../data/models/cart_response_model.dart';
import '../../data/models/fast_foods_models/brand_model.dart';
import '../../data/models/fast_foods_models/category_response_model.dart';
import '../../data/models/fast_foods_models/daily_deal_model.dart';
import '../../data/models/fast_foods_models/deal_details_model.dart';
import '../../data/models/fast_foods_models/fast_delivery_restaurant_model.dart';
import '../../data/models/fast_foods_models/home_chef_model.dart';
import '../../data/models/fast_foods_models/popular_product_model.dart';
import '../../data/models/fast_foods_models/product_by_category_response_model.dart';
import '../../data/models/fast_foods_models/promotion_deal_model.dart';
import '../../data/models/fast_foods_models/restaurant_response_models.dart';
import '../../data/models/fast_foods_models/sub_category_response_model.dart';
import '../../data/models/chat_messages_response_model.dart';
import '../../data/models/conversation_response_model.dart';
import '../../data/models/favourite_response_model.dart';
import '../../data/models/google_login_response_model.dart';
import '../../data/models/grocery_category_model.dart';
import '../../data/models/my_orders_response_model.dart';
import '../../data/models/onboarding_model.dart';
import '../../data/models/onboarding_response_model.dart';
import '../../data/models/order_detail_response_model.dart';
import '../../data/models/place_order_response_model.dart';
import '../../data/models/products_response_model.dart';
import '../../data/models/profile_response_model.dart';
import '../../data/models/remove_favourite_response_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/tracking_model.dart';
import '../../data/models/update_profile_picture_response_model.dart';


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

  @PATCH("wishlist/toggle")
  Future<WishlistToggleResponseModel> toggleWishlist(
      @Body() Map<String, dynamic> body,
      );

  @GET("wishlist")
  Future<FavoriteResponse> getFavorites();

  @DELETE("wishlist/remove/{productId}")
  Future<RemoveFavouriteResponseModel> removeFavorite(
      @Path("productId") String productId,
      );

  @GET("products/product-by-category")
  Future<ProductsResponseModel> getProducts(
      @Query("category") String? category,
      );

  @GET("categories")
  Future<GroceryCategoryResponse> getGroceryCategories(
      @Query("categorySlug") String categorySlug,
      );


  @GET("cart")
  Future<CartResponseModel> getCartItem();


  @POST("cart/add")
  Future<CartResponseModel> addToCart(
      @Body() Map<String, dynamic> body,
      );

  // @POST("cart/bulk-add")
  // Future<CartResponseModel> bulkAddToCart(
  //     @Body() Map<String, dynamic> body,
  //     );

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

  @GET("feedback")
  Future<FeedbackResponse> getFeedbacks();

  @POST("feedback")
  Future<SubmitFeedbackResponse> submitFeedback(
    @Body() Map<String, dynamic> body,
  );

  @GET("categories")
  Future<CategoryResponseModel> getCategories();

  @GET("categories/{categoryId}/subcategories")
  Future<SubCategoryResponseModel> getSubCategories(
      @Path("categoryId") String categoryId,
      );

  @GET("products/product-by-category")
  Future<ProductByCategoryResponseModel>
  getProductsByCategory(
      @Query("category") String category,
      @Query("subcategory") String subcategory,
      );

  @GET("deals")
  Future<PromotionDealResponseModel> getPromotionDeals();


  @GET("deals/deal-details/{dealId}")
  Future<DealDetailResponseModel> getDealDetails(
      @Path("dealId") String dealId,
      );


  @GET("restaurants/brands")
  Future<BrandResponseModel> getRestaurantBrands();

  @GET("homeChefs")
  Future<HomeChefResponseModel> getHomeChefs();

  @GET("restaurants/fast-delivery")
  Future<FastDeliveryResponseModel> getFastDeliveryRestaurants();

  @GET("deals/daily/")
  Future<DailyDealsResponseModel> getDailyDeals(
      @Query("type") String type,
      );

  @GET("products/product-by-type")
  Future<PopularProductsResponseModel> getPopularProducts(
      @Query("type") String type, // Pass "popular"
      );

  // =====================================================
// RESTAURANT DETAILS
// GET /api/restaurants/{restaurantId}
// =====================================================

  @GET("restaurants/{restaurantId}")
  Future<RestaurantDetailsResponseModel> getRestaurantDetails(
      @Path("restaurantId") String restaurantId,
      );


// =====================================================
// RESTAURANT CATEGORIES
// GET /api/restaurants/categories/{restaurantId}
// =====================================================

  @GET("restaurants/categories/{restaurantId}")
  Future<RestaurantCategoriesResponseModel> getRestaurantCategories(
      @Path("restaurantId") String restaurantId,
      );


// =====================================================
// RESTAURANT MENU
// GET /api/restaurants/menu/{restaurantId}
// =====================================================

  @GET("restaurants/menu/{restaurantId}")
  Future<dynamic> getRestaurantMenu(
      @Path("restaurantId") String restaurantId,
      );


// =====================================================
// PRODUCTS BY RESTAURANT CATEGORY
// GET /api/products/product-by-restaurant-categories/{restaurantId}?categoryName=pizza
// =====================================================

  @GET("products/product-by-restaurant-categories/{restaurantId}")
  Future<RestaurantCategoryProductsResponseModel>
  getProductsByRestaurantCategory(
      @Path("restaurantId") String restaurantId,
      @Query("categoryName") String categoryName,
      );


  @GET("orders/track/{id}")
  Future<TrackingModel> getTracking(
      @Path("id") String orderId,
      );

  @POST("chat/create-conversation")
  Future<ConversationResponseModel> createConversation(
      @Body() Map<String, dynamic> body,
      );

  @GET("chat/messages/{conversationId}")
  Future<ChatMessagesResponseModel> getChatMessages(
      @Path("conversationId") String conversationId,
      );
  
  @GET("auth/my-profile/{id}")
  Future<ProfileResponseModel>
  getMyProfile(
      @Path("id") String userId,
      );

  @PUT("auth/my-profile/update/{id}")
  Future<UpdateProfilePictureResponseModel>
  updateProfilePicture(
      @Path("id") String userId,
      @Body() Map<String, dynamic> body, );
}
