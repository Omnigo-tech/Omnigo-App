
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/datasource/repositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc(this.repository) : super(OnboardingInitial()) {

    on<GetOnboardingDataEvent>((event, emit) async {
      emit(OnboardingLoading());

      try {
        final data = await repository.fetchOnboardingData();
        emit(OnboardingSuccess(data));
      } on ServerException catch (e) {
        emit(OnboardingFailure(e.message));
      } on NetworkException catch (e) {
        emit(OnboardingFailure(e.message));
      } catch (e) {
        emit(OnboardingFailure("Unexpected error occurred"));
      }
    });
  }
}