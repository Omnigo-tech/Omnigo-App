import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

// Nested user object from API response
@JsonSerializable()
class ReviewUser {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'profileImage')
  final String? profileImage;

  ReviewUser({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) =>
      _$ReviewUserFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewUserToJson(this);
}

@JsonSerializable()
class ReviewModel {
  @JsonKey(name: '_id')
  final String id;

  // user is a nested object from API
  final ReviewUser user;
  final double rating;

  @JsonKey(name: 'message')
  final String comment;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'feedbackType')
  final String? feedbackType;

  // Store raw ISO date from API
  @JsonKey(name: 'createdAt')
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    this.image,
    this.feedbackType,
    required this.createdAt,
  });

  // Computed property: convert createdAt → "2d ago", "3h ago" etc.
  String get timeAgo {
    try {
      final date = DateTime.parse(createdAt).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inDays >= 365) {
        final years = (diff.inDays / 365).floor();
        return "${years}y ago";
      } else if (diff.inDays >= 30) {
        final months = (diff.inDays / 30).floor();
        return "${months}mo ago";
      } else if (diff.inDays >= 1) {
        return "${diff.inDays}d ago";
      } else if (diff.inHours >= 1) {
        return "${diff.inHours}h ago";
      } else if (diff.inMinutes >= 1) {
        return "${diff.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (_) {
      return "Recently";
    }
  }

  // Get user name safely
  String get userName => user.name;

  // Get user image safely (fallback to avatar if empty)
  String get userImg {
    final img = user.profileImage ?? "";
    return img.isNotEmpty
        ? img
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name)}&background=4CAF50&color=fff";
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

// Wrapper for GET /api/feedback response
@JsonSerializable()
class FeedbackResponse {
  final bool success;
  final int count;
  final List<ReviewModel> data;

  FeedbackResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackResponseToJson(this);
}

// Wrapper for POST /api/feedback response
@JsonSerializable()
class SubmitFeedbackResponse {
  final bool success;
  final String message;

  SubmitFeedbackResponse({required this.success, required this.message});

  factory SubmitFeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitFeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitFeedbackResponseToJson(this);
}


