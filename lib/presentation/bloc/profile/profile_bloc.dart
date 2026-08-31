import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/repositories/profile_repository.dart';
import '../../../data/models/profile_response_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
final ProfileRepository profileRepository;

ProfileBloc(this.profileRepository)
    : super(const ProfileState()) {
on<LoadProfileEvent>(_onLoadProfile);
on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
}

Future<void> _onLoadProfile(
LoadProfileEvent event,
Emitter<ProfileState> emit,
) async {
emit(
state.copyWith(
isLoading: true,
clearError: true,
clearSuccess: true,
),
);

try {
final response =
await profileRepository.getMyProfile(event.userId);

if (response.success) {
emit(
state.copyWith(
isLoading: false,
profile: response,
),
);
} else {
emit(
state.copyWith(
isLoading: false,
errorMessage: "Unable to load profile",
),
);
}
} catch (e) {
emit(
state.copyWith(
isLoading: false,
errorMessage: e.toString(),
),
);
}
}

Future<void> _onUpdateProfilePicture(
UpdateProfilePictureEvent event,
Emitter<ProfileState> emit,
) async {
emit(
state.copyWith(
isUpdatingPicture: true,
clearError: true,
clearSuccess: true,
),
);

try {
final response =
await profileRepository.updateProfilePicture(
event.userId,
event.profilePicture,
);

if (response.success) {
// Update existing profile locally
final currentProfile = state.profile;

if (currentProfile != null &&
response.user != null) {
final oldUser = currentProfile.userProfile!.user;

final updatedUser = ProfileUser(
id: oldUser.id,
name: oldUser.name,
email: oldUser.email,
phone: oldUser.phone,
profilePicture:
response.user!.profilePicture,
isBlocked: oldUser.isBlocked,
addresses: oldUser.addresses,
);

final updatedProfileUser =
ProfileUserData(user: updatedUser);

final updatedProfile = ProfileResponseModel(
success: currentProfile.success,
userProfile: updatedProfileUser,
order: currentProfile.order,
pendingOrder: currentProfile.pendingOrder,
savedItemsCount:
currentProfile.savedItemsCount,
cartItems: currentProfile.cartItems,
);

emit(
state.copyWith(
isUpdatingPicture: false,
profile: updatedProfile,
successMessage: response.message,
),
);
} else {
emit(
state.copyWith(
isUpdatingPicture: false,
successMessage: response.message,
),
);
}
} else {
emit(
state.copyWith(
isUpdatingPicture: false,
errorMessage:
response.message.isNotEmpty
? response.message
    : "Profile picture update failed",
),
);
}
} catch (e) {
emit(
state.copyWith(
isUpdatingPicture: false,
errorMessage: e.toString(),
),
);
}
}
}
