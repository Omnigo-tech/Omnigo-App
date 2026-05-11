import 'package:grocery_app/data/models/review_model.dart';

abstract class ReviewEvent {}

class FetchReviewsEvent extends ReviewEvent {
}
class AddReviewEvent extends ReviewEvent {
  final ReviewModel newReview;
  AddReviewEvent(this.newReview);
}
