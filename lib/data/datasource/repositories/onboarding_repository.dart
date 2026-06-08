
import 'package:dio/dio.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/network/api_service.dart';
import '../../models/onboarding_model.dart';

class OnboardingRepository {
  final ApiService apiService;

  OnboardingRepository(this.apiService);

  Future<List<OnboardingModel>> fetchOnboardingData() async {
    try {
      final response = await apiService.getOnboardingData();
      return response.data;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}