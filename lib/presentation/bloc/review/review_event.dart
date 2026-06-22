abstract class ReviewEvent {}

// Fetch all reviews from API
class FetchReviewsEvent extends ReviewEvent {}

// Submit new review to API then refetch
class AddReviewEvent extends ReviewEvent {
  final double rating;
  final String message;

  AddReviewEvent({required this.rating, required this.message});
}

/*import 'package:grocery_app/data/models/review_model.dart';

abstract class ReviewEvent {}

class FetchReviewsEvent extends ReviewEvent {
}
class AddReviewEvent extends ReviewEvent {
  final ReviewModel newReview;
  AddReviewEvent(this.newReview);
}*/
