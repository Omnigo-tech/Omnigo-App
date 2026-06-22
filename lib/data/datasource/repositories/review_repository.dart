import 'package:dio/dio.dart';
import 'package:grocery_app/core/error/error_handler.dart';
import 'package:grocery_app/core/network/api_service.dart';
import 'package:grocery_app/data/models/review_model.dart';

class ReviewRepository {
  final ApiService apiService;

  ReviewRepository(this.apiService);

  // GET all feedbacks from API
  Future<List<ReviewModel>> getFeedbacks() async {
    try {
      final response = await apiService.getFeedbacks();
      return response.data;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // POST submit feedback to API
  Future<void> submitFeedback({
    required double rating,
    required String message,
  }) async {
    try {
      await apiService.submitFeedback({"rating": rating, "message": message});
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
