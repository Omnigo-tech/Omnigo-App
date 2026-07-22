import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';

import '../../../../widgets/ProfileMenuTile.dart';
import '../../../../widgets/profile_header.dart';
import '../../../../widgets/profile_stats_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Profile",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              ProfileHeader(
                name: "Ali Raza",
                phone: "+92 312 3456789",
                imageUrl:
                "https://i.pravatar.cc/300",
                onEdit: () {},
              ),

              SizedBox(height: 24.h),

              /// Stats
              const ProfileStatsSection(),

              SizedBox(height: 28.h),

              /// Menu
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: [

                    ProfileMenuTile(
                      icon: Icons.person_outline,
                      title: "Personal Information",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.location_on_outlined,
                      title: "My Addresses",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.shopping_bag_outlined,
                      title: "My Orders",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.favorite_border,
                      title: "Wishlist",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.payment_outlined,
                      title: "Payment Methods",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.help_outline,
                      title: "Help Center",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.info_outline,
                      title: "About App",
                      onTap: () {},
                    ),

                    ProfileMenuTile(
                      icon: Icons.logout,
                      title: "Logout",
                      iconColor: Colors.red,
                      showDivider: false,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text(
            "Logout",
          ),

          content: const Text(
            "Are you sure you want to logout?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);

                /// TODO
                /// Call Logout Bloc

              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}