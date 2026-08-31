abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
final String userId;

LoadProfileEvent(this.userId);
}

class UpdateProfilePictureEvent extends ProfileEvent {
final String userId;
final String profilePicture;

UpdateProfilePictureEvent({
required this.userId,
required this.profilePicture,
});
}
