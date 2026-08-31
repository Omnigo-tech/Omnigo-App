class ProfileResponseModel {
final bool success;
final ProfileUserData? userProfile;
final int order;
final int pendingOrder;
final int savedItemsCount;
final int cartItems;

ProfileResponseModel({
required this.success,
this.userProfile,
required this.order,
required this.pendingOrder,
required this.savedItemsCount,
required this.cartItems,
});

factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
final userProfileJson = json['userProfile'];

return ProfileResponseModel(
success: json['success'] ?? false,
userProfile: userProfileJson != null
? ProfileUserData.fromJson(userProfileJson)
    : null,
order: userProfileJson?['order'] ?? 0,
pendingOrder: userProfileJson?['PendingOrder'] ?? 0,
savedItemsCount: userProfileJson?['savedItemsCount'] ?? 0,
cartItems: userProfileJson?['cartItems'] ?? 0,
);
}
}

class ProfileUserData {
final ProfileUser user;

ProfileUserData({
required this.user,
});

factory ProfileUserData.fromJson(Map<String, dynamic> json) {
return ProfileUserData(
user: ProfileUser.fromJson(json['user'] ?? {}),
);
}
}

class ProfileUser {
final String id;
final String name;
final String email;
final String phone;
final String profilePicture;
final bool isBlocked;
final List<ProfileAddress> addresses;

ProfileUser({
required this.id,
required this.name,
required this.email,
required this.phone,
required this.profilePicture,
required this.isBlocked,
required this.addresses,
});

factory ProfileUser.fromJson(Map<String, dynamic> json) {
return ProfileUser(
id: json['_id'] ?? '',
name: json['name'] ?? '',
email: json['email'] ?? '',
phone: json['phone'] ?? '',
profilePicture: json['profilePicture'] ?? '',
isBlocked: json['isBlocked'] ?? false,
addresses: (json['addresses'] as List?)
    ?.map((e) => ProfileAddress.fromJson(e))
    .toList() ??
[],
);
}
}

class ProfileAddress {
final String id;
final String address;
final String city;
final String zipCode;
final String country;
final bool isDefault;

ProfileAddress({
required this.id,
required this.address,
required this.city,
required this.zipCode,
required this.country,
required this.isDefault,
});

factory ProfileAddress.fromJson(Map<String, dynamic> json) {
return ProfileAddress(
id: json['_id'] ?? '',
address: json['address'] ?? '',
city: json['city'] ?? '',
zipCode: json['zipCode'] ?? '',
country: json['country'] ?? '',
isDefault: json['isDefault'] ?? false,
);
}
}
