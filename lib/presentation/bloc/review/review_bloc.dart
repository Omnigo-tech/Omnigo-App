import 'package:bloc/bloc.dart';
import 'package:grocery_app/presentation/bloc/review/review_event.dart';
import 'package:grocery_app/presentation/bloc/review/review_state.dart';
import 'package:meta/meta.dart';

import '../../../data/models/review_model.dart';



class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<FetchReviewsEvent>((event, emit) async {
      emit(ReviewLoading());
      try {
        // Yahan aap API call kar saktay hain
        await Future.delayed(const Duration(seconds: 1));
        // emit(ReviewLoaded([
        //   ReviewModel(
        //     userName: "Hira ali",
        //     userImg: "https://i.pravatar.cc/150?u=hira",
        //     rating: 5.0,
        //     comment: "Super fast delivery! Loved the packaging.",
        //     timeAgo: "2 mins ago",
        //   ),
        // ]));
        emit(ReviewLoaded([]));
      } catch (e) {
        emit(ReviewError("Failed to load reviews"));
      }
    });

    on<AddReviewEvent>((event, emit) {
      if (state is ReviewLoaded) {
        final List<ReviewModel> updatedList = List.from((state as ReviewLoaded).reviews)
          ..insert(0, event.newReview);
        emit(ReviewLoaded(updatedList));
      }
    });
  }
}
