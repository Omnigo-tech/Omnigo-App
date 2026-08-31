import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:grocery_app/presentation/bloc/profile/profile_event.dart';
import 'package:grocery_app/presentation/bloc/profile/profile_state.dart';
import 'package:grocery_app/widgets/ProfileMenuTile.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import 'package:grocery_app/widgets/profile_header.dart';
import 'package:grocery_app/widgets/profile_stats_section.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../data/datasource/local/auth_local_data_source.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final userId = sl<AuthLocalDataSource>().getUserId();

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(LoadProfileEvent(userId!));
  }

  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DimensionsResources.RADIUS_EXTRA_LARGE.r),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Profile Picture",
                  style: TextStyle(
                    fontSize: DimensionsResources.FONT_SIZE_1X_EXTRA_MEDIUM.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: DimensionsResources.D_20.h),

                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (pickedFile == null) {
        return;
      }

      final file = File(pickedFile.path);

      // ------------------------------------------------
      // IMPORTANT:
      // Tumhari current backend PUT API String URL
      // receive karti hai:
      //
      // {
      //   "profilePicture": "https://..."
      // }
      //
      // Isliye local File path directly API ko nahi
      // bhej sakte.
      //
      // Backend par image upload endpoint chahiye
      // jo File ko upload karke URL return kare.
      // ------------------------------------------------

      debugPrint("Selected image: ${file.path}");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Image selected. Image upload API is required to send this file to server.",
          ),
        ),
      );
    } catch (e) {
      debugPrint("Pick image error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppBar(title: StringResources.profile),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;

        final user = profile?.userProfile?.user;

        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppBar(title: StringResources.profile),
            body: const Center(child: Text("Unable to load profile")),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(title: StringResources.profile),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: DimensionsResources.D_10.h),

                  ProfileHeader(
                    name: user.name,
                    phone: user.phone,
                    imageUrl: user.profilePicture,
                    onEdit: _showImagePicker,
                  ),

                  SizedBox(height: DimensionsResources.D_24.h),

                  ProfileStatsSection(
                    orders: profile!.order,
                    pendingOrders: profile.pendingOrder,
                    savedItems: profile.savedItemsCount,
                    cartItems: profile.cartItems,
                  ),

                  SizedBox(height: DimensionsResources.D_28.h),

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: DimensionsResources.D_20.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        DimensionsResources.RADIUS_EXTRA_LARGE.r,
                      ),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuTile(
                          icon: Icons.person_outline,
                          title: StringResources.personalInformation,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.location_on_outlined,
                          title: StringResources.myAddresses,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.shopping_bag_outlined,
                          title: StringResources.myOrders,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.favorite_border,
                          title: StringResources.wishlist,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.notifications_none,
                          title: StringResources.notifications,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.payment_outlined,
                          title: StringResources.paymentMethods,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.lock_outline,
                          title: StringResources.changePassword,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.help_outline,
                          title: StringResources.helpCenter,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.info_outline,
                          title: StringResources.aboutApp,
                          onTap: () {},
                        ),

                        ProfileMenuTile(
                          icon: Icons.logout,
                          title: StringResources.logout,
                          iconColor: AppColors.red,
                          showDivider: false,
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: DimensionsResources.D_30.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionsResources.RADIUS_LARGE.r,
            ),
          ),
          title: const Text(StringResources.logout),
          content: const Text(StringResources.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(StringResources.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // TODO: Logout Bloc
              },
              child: const Text(StringResources.logout),
            ),
          ],
        );
      },
    );
  }
}
