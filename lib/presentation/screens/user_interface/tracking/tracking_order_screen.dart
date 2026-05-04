import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_state.dart';

import '../../../../core/helper/utils/launcher_helper.dart';

class TrackingOrderScreen extends StatelessWidget {
  const TrackingOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(child: SpinKitThreeInOut(
              color: AppColors.primary,
              size: DimensionsResources.FONT_SIZE_EXTRA_EXTRA_LARGE,
            ));
          }

          if (state is TrackingError) {
            return Center(child: Text(state.message));
          }

          if (state is TrackingLoaded) {
            final tracking = state.trackingModel;
            return Stack(
              children: [
                Positioned.fill(
                  bottom: DimensionsResources.D_400.h,
                  child: Image.asset(
                    ImageResource.TRACKING_ORDER_IMG,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: AppColors.lightBackground),
                  ),
                ),

                Positioned(
                  top: DimensionsResources.D_50.h,
                  left: DimensionsResources.D_20.w,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(DimensionsResources.D_8.w),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child:  SvgPicture.asset(
                        ImageResource.BACK_ICON,
                        width: DimensionsResources.D_30.w,
                        height: DimensionsResources.D_30.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.darkSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: DimensionsResources.D_420.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(DimensionsResources.D_30.r),
                        topRight: Radius.circular(DimensionsResources.D_30.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: DimensionsResources.D_10.r,
                          spreadRadius: DimensionsResources.D_5.r,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(DimensionsResources.D_24.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: DimensionsResources.D_40.w,
                              height: DimensionsResources.D_4.h,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(DimensionsResources.D_2.r),
                              ),
                            ),
                          ),
                          SizedBox(height: DimensionsResources.D_20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tracking.status,
                                style:Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.black
                                )),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_12.w, vertical: DimensionsResources.D_6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteTranslucent,
                                  borderRadius: BorderRadius.circular(DimensionsResources.D_20.r),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 0.5.w,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImageResource.CLOCK_ICON,
                                      width: DimensionsResources.D_16.w,
                                      height: DimensionsResources.D_16.h,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: DimensionsResources.D_4.w),
                                    Text(
                                      tracking.estimatedTime,
                                      style:Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: DimensionsResources.D_25.h),

                          // Progress Bar
                          _buildProgressBar(tracking.progress),

                          SizedBox(height: DimensionsResources.D_30.h),

                          // Delivery Hero Info
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: Image.asset(ImageResource.RIDER_IMG).image,
                                radius: DimensionsResources.D_25.r,
                                backgroundColor: AppColors.itemBackground,
                              ),
                              SizedBox(width: DimensionsResources.D_15.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringResources.deliveryhero,
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.grey
                                      ),
                                    ),
                                    Text(
                                      tracking.deliveryHeroName,
                                      style:Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: AppColors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildActionIcon(
                                ImageResource.MESSAGE_ICON,
                                AppColors.fieldBg,
                                AppColors.primary,
                                    () {
                                  LauncherHelper.sendSMS(tracking.phonenumber);
                                },
                              ),
                              SizedBox(width: DimensionsResources.D_10.w),
                              _buildActionIcon(
                                  ImageResource.CALL_ICON,
                                  AppColors.fieldBg,
                                  AppColors.primary,
                                    () {
                                  LauncherHelper.makePhoneCall(tracking.phonenumber);
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: DimensionsResources.D_25.h),

                          _buildTimelineItem(
                            context: context,
                            iconImage: ImageResource.STORE_ICON,
                            label: StringResources.store,
                            value: tracking.storeName,
                            isLast: false,
                          ),

                          _buildTimelineItem(
                            context: context,

                            iconImage: ImageResource.LOCATION_ICON,
                            label: StringResources.yourplace,
                            value: tracking.destinationAddress,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: AppColors.primary, size: 24.sp),
        Expanded(child: Container(height: DimensionsResources.D_4.h.h, color: AppColors.primary)),
        SvgPicture.asset(
          ImageResource.BYKE_ICON,
          width: DimensionsResources.D_24.w,
          height: DimensionsResources.D_24.h,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        Expanded(child: Container(height: DimensionsResources.D_4.h, color: AppColors.border)),
        SvgPicture.asset(
          ImageResource.HOME_DELIVERED_ICON,
          width: DimensionsResources.D_24.w,
          height: DimensionsResources.D_24.h,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        Expanded(child: Container(height: DimensionsResources.D_4.h, color: AppColors.border)),
        SvgPicture.asset(
          ImageResource.LOCATION_ICON,
          width: DimensionsResources.D_24.w,
          height: DimensionsResources.D_24.h,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(
      String svgPath,
      Color bgColor,
      Color iconColor,
      VoidCallback onTap,
      ) {
    return Container(
      width: DimensionsResources.D_46.w,
      height: DimensionsResources.D_46.h,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          onPressed: onTap,
          icon: Center(
            child: SvgPicture.asset(
              svgPath,
              width: DimensionsResources.D_20.w,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      )
    );
  }

  Widget _buildTimelineItem({
    required String iconImage,
    required String label,
    required String value,
    required bool isLast,
    required BuildContext context,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
         SvgPicture.asset(
          iconImage,
          width: DimensionsResources.D_16.w,
          height: DimensionsResources.D_16.h,
      ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: DimensionsResources.D_1.w,
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          SizedBox(width: DimensionsResources.D_15.w),
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? DimensionsResources.D_0 : DimensionsResources.D_25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.grey
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color:AppColors.black
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
