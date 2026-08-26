import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/constants/colors_resources.dart';
import '../../../../../core/helper/constants/dimensions-resource.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String phone;
  final String? imageUrl;
  final bool isOnline;
  final VoidCallback? onEdit;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    this.imageUrl,
    this.isOnline = true,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 42.r,
              backgroundColor: AppColors.primary.withOpacity(.10),
              backgroundImage:
              imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : null,
              child: imageUrl == null || imageUrl!.isEmpty
                  ? Icon(
                Icons.person,
                size: 42.sp,
                color: AppColors.primary,
              )
                  : null,
            ),

            if (isOnline)
              Positioned(
                right: 2,
                bottom: 4,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),

            if (onEdit != null)
              Positioned(
                top: -4,
                right: -4,
                child: InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: DimensionsResources.D_12.h),

        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          phone,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}