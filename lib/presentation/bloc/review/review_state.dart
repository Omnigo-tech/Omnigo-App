import 'package:grocery_app/data/models/review_model.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSubmitting extends ReviewState {
  final List<ReviewModel> currentReviews;
  ReviewSubmitting(this.currentReviews);
}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;

  // Calculated from real API data
  final double averageRating;

  // Count of each star rating (1-5) for progress bars
  // e.g. ratingCounts[5] = 8 means 8 people gave 5 stars
  final Map<int, int> ratingCounts;

  ReviewLoaded({
    required this.reviews,
    required this.averageRating,
    required this.ratingCounts,
  });

  // Helper: get progress value (0.0 to 1.0) for each star
  double progressFor(int star) {
    if (reviews.isEmpty) return 0.0;
    final count = ratingCounts[star] ?? 0;
    return count / reviews.length;
  }
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

class ReviewSubmitSuccess extends ReviewState {}

class ReviewSubmitError extends ReviewState {
  final String message;
  ReviewSubmitError(this.message);
}









/*import 'package:grocery_app/data/models/review_model.dart';
abstract class ReviewState {}
class ReviewInitial extends ReviewState {}
class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  ReviewLoaded(this.reviews);
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}*/