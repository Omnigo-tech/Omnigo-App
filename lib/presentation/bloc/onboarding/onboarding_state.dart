

import '../../../data/models/onboarding_model.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {
  final List<OnboardingModel> onboardingData;
  OnboardingSuccess(this.onboardingData);
}

class OnboardingFailure extends OnboardingState {
  final String error;
  OnboardingFailure(this.error);
}