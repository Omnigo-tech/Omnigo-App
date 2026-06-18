// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewUser _$ReviewUserFromJson(Map<String, dynamic> json) => ReviewUser(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$ReviewUserToJson(ReviewUser instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profileImage': instance.profileImage,
    };

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['_id'] as String,
  user: ReviewUser.fromJson(json['user'] as Map<String, dynamic>),
  rating: (json['rating'] as num).toDouble(),
  comment: json['message'] as String,
  image: json['image'] as String?,
  feedbackType: json['feedbackType'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'rating': instance.rating,
      'message': instance.comment,
      'image': instance.image,
      'feedbackType': instance.feedbackType,
      'createdAt': instance.createdAt,
    };

FeedbackResponse _$FeedbackResponseFromJson(Map<String, dynamic> json) =>
    FeedbackResponse(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedbackResponseToJson(FeedbackResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };

SubmitFeedbackResponse _$SubmitFeedbackResponseFromJson(
  Map<String, dynamic> json,
) => SubmitFeedbackResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$SubmitFeedbackResponseToJson(
  SubmitFeedbackResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
