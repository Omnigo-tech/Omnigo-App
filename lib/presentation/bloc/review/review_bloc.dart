import 'package:bloc/bloc.dart';
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
}