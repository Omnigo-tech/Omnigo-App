class UpdateProfilePictureResponseModel {
final bool success;
final String message;
final UpdatedProfileUser? user;

UpdateProfilePictureResponseModel({
required this.success,
required this.message,
this.user,
});

factory UpdateProfilePictureResponseModel.fromJson(
Map<String, dynamic> json,
) {
return UpdateProfilePictureResponseModel(
success: json['success'] ?? false,
message: json['message'] ?? '',
user: json['user'] != null
? UpdatedProfileUser.fromJson(json['user'])
    : null,
);
}
}

class UpdatedProfileUser {
final String id;
final String profilePicture;

UpdatedProfileUser({
required this.id,
required this.profilePicture,
});

factory UpdatedProfileUser.fromJson(Map<String, dynamic> json) {
return UpdatedProfileUser(
id: json['id'] ?? '',
profilePicture: json['profilePicture'] ?? '',
);
}
}
