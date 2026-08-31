import '../../../data/models/profile_response_model.dart';

class ProfileState {
final bool isLoading;
final bool isUpdatingPicture;
final ProfileResponseModel? profile;
final String? errorMessage;
final String? successMessage;

const ProfileState({
this.isLoading = false,
this.isUpdatingPicture = false,
this.profile,
this.errorMessage,
this.successMessage,
});

ProfileState copyWith({
bool? isLoading,
bool? isUpdatingPicture,
ProfileResponseModel? profile,
String? errorMessage,
String? successMessage,
bool clearError = false,
bool clearSuccess = false,
}) {
return ProfileState(
isLoading: isLoading ?? this.isLoading,
isUpdatingPicture:
isUpdatingPicture ?? this.isUpdatingPicture,
profile: profile ?? this.profile,
errorMessage:
clearError ? null : errorMessage ?? this.errorMessage,
successMessage:
clearSuccess ? null : successMessage ?? this.successMessage,
);
}
}
