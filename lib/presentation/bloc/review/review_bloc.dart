import 'package:bloc/bloc.dart';
import 'package:grocery_app/data/datasource/repositories/review_repository.dart';
import 'package:grocery_app/data/models/review_model.dart';
import 'package:grocery_app/presentation/bloc/review/review_event.dart';
import 'package:grocery_app/presentation/bloc/review/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc(this.repository) : super(ReviewInitial()) {
    on<FetchReviewsEvent>(_fetchReviews);
    on<AddReviewEvent>(_addReview);
  }

  // Fetch all reviews from GET API
  Future<void> _fetchReviews(
    FetchReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await repository.getFeedbacks();
      emit(_buildLoadedState(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  // Submit review via POST API then refetch all reviews (Option A)
  Future<void> _addReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    // Keep showing current reviews while submitting
    final currentReviews = state is ReviewLoaded
        ? (state as ReviewLoaded).reviews
        : [];

    emit(ReviewSubmitting(List<ReviewModel>.from(currentReviews)));

    try {
      // Step 1: POST to API
      await repository.submitFeedback(
        rating: event.rating,
        message: event.message,
      );

      // Step 2: Refetch all reviews so list is fresh from server
      final updatedReviews = await repository.getFeedbacks();

      emit(_buildLoadedState(updatedReviews));
      emit(ReviewSubmitSuccess());
    } catch (e) {
      // Restore previous reviews on error
      emit(_buildLoadedState(List<ReviewModel>.from(currentReviews)));
      emit(ReviewSubmitError(e.toString()));
    }
  }

  // Calculate average rating and rating counts from reviews list
  ReviewLoaded _buildLoadedState(List<ReviewModel> reviews) {
    double totalRating = 0;
    final Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (final review in reviews) {
      totalRating += review.rating;
      // Round to nearest star for count
      final star = review.rating.round().clamp(1, 5);
      ratingCounts[star] = (ratingCounts[star] ?? 0) + 1;
    }

    final averageRating = reviews.isEmpty ? 0.0 : totalRating / reviews.length;

    return ReviewLoaded(
      reviews: reviews,
      averageRating: double.parse(averageRating.toStringAsFixed(1)),
      ratingCounts: ratingCounts,
    );
  }
}













/*import 'package:bloc/bloc.dart';
import 'package:grocery_app/presentation/bloc/review/review_event.dart';
import 'package:grocery_app/presentation/bloc/review/review_state.dart';

import '../../../data/models/review_model.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {

  final List<ReviewModel> _reviews = [];

  ReviewBloc() : super(ReviewInitial()) {

    on<FetchReviewsEvent>((event, emit) async {

      emit(ReviewLoading());

      try {

        await Future.delayed(const Duration(seconds: 1));

        // Existing reviews show karo
        emit(ReviewLoaded(List.from(_reviews)));

      } catch (e) {

        emit(ReviewError("Failed to load reviews"));
      }
    });

    // Add Review
    on<AddReviewEvent>((event, emit) {

      // New review add
      _reviews.insert(0, event.newReview);

      // Updated list emit
      emit(ReviewLoaded(List.from(_reviews)));
    });
  }
}*/