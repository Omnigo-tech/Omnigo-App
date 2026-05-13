class ReviewModel {
  final String userName;
  final String userImg;
  final double rating;
  final String comment;
  final List<String> reviewImages;
  final String? storeResponse;
  final String timeAgo;

  ReviewModel({
    required this.userName,
    required this.userImg,
    required this.rating,
    required this.comment,
    this.reviewImages = const[],
    this.storeResponse,
    required this.timeAgo,
  });
}