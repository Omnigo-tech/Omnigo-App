import 'onboarding_model.dart';

class OnboardingResponseModel {
  final bool success;
  final String message;
  final List<OnboardingModel> data;

  OnboardingResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OnboardingResponseModel.fromJson(
      Map<String, dynamic> json) {
    return OnboardingResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => OnboardingModel.fromJson(e))
          .toList(),
    );
  }
}