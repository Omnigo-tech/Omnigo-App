import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_event.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_state.dart';
import 'package:grocery_app/widgets/tracking_info_card.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../data/datasource/remote/socket_service.dart';
import '../../../../data/datasource/repositories/chat_repository.dart';

class TrackingOrderScreen extends StatefulWidget {
  final String orderId;
  final String userId;

  const TrackingOrderScreen({
    super.key,
    required this.orderId,
    required this.userId,
  });

  @override
  State<TrackingOrderScreen> createState() => _TrackingOrderScreenState();
}

class _TrackingOrderScreenState extends State<TrackingOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TrackingBloc>().add(
      FetchTrackingDetails(orderId: widget.orderId, userId: widget.userId),
    );
  }
  @override
  void dispose() {
    sl<SocketService>().leaveOrderTrackingRoom(widget.orderId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(
              child: SpinKitThreeInOut(
                color: AppColors.primary,
                size: DimensionsResources.FONT_SIZE_EXTRA_EXTRA_LARGE,
              ),
            );
          }

          if (state is TrackingError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(DimensionsResources.D_20.w),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
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
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.lightBackground),
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
                      child: SvgPicture.asset(
                        ImageResource.BACK_ICON,
                        width: DimensionsResources.D_30.w,
                        height: DimensionsResources.D_30.h,
                        colorFilter: const ColorFilter.mode(
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
                          color: Colors.black.withValues(alpha: 0.05),
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
                                borderRadius: BorderRadius.circular(
                                  DimensionsResources.D_2.r,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: DimensionsResources.D_20.h),

                          // Dynamic Tracking Card with dynamic socket mapping
                          TrackingInfoCard(
                            status: tracking.status,
                            estimatedTime: tracking.estimatedTime,
                            riderName: tracking.deliveryHeroName ?? "Assigning Rider...",
                            riderTitle: StringResources.deliveryhero,
                            riderImage: ImageResource.RIDER_IMG,

                            clockIcon: ImageResource.CLOCK_ICON,
                            bikeIcon: ImageResource.BYKE_ICON,
                            deliveredIcon: ImageResource.HOME_DELIVERED_ICON,
                            locationIcon: ImageResource.LOCATION_ICON,
                            messageIcon: ImageResource.MESSAGE_ICON,
                            callIcon: ImageResource.CALL_ICON,

                            primaryColor: AppColors.primary,
                            iconBgColor: AppColors.fieldBg,
                            iconColor: AppColors.primary,

                            onMessageTap: () async {
                              // Show standard loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );

                              try {
                                final chatRepo = sl<ChatRepository>();
                                final response = await chatRepo.createConversation(widget.orderId);

                                Navigator.pop(context); // Close loading dialog

                                if (response.success && response.conversation != null) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.chat,
                                    arguments: {
                                      'conversationId': response.conversation!.id,
                                      'receiverId': response.conversation!.riderId,
                                      'receiverName': tracking.deliveryHeroName ?? "Rider",
                                      'currentUserId': widget.userId,
                                    },
                                  );
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to init conversation: $e")),
                                );
                              }
                            },

                            onCallTap: () async {
                              if (tracking.phonenumber == null || tracking.phonenumber!.isEmpty) return;

                              // 1. Screen par loading blocker show karein
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );

                              try {
                                // 2. ChatRepository se conversationId generate ya fetch karein
                                final chatRepo = sl<ChatRepository>();
                                final response = await chatRepo.createConversation(widget.orderId);

                                Navigator.pop(context); // Loading dialog ko band karein

                                if (response.success && response.conversation != null) {
                                  // 3. Dynamic payload pass kar ke updated sheet open karein
                                  GlobalDialogs.showCallDriverSheet(
                                    context,
                                    phoneNumber: tracking.phonenumber!,
                                    conversationId: response.conversation!.id,
                                    receiverId: response.conversation!.riderId,
                                    currentUserId: widget.userId,
                                    receiverName: tracking.deliveryHeroName ?? "Rider",
                                  );
                                }
                              } catch (e) {
                                Navigator.pop(context); // Error aane par bhi loading band karein
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to initialize call session: $e")),
                                );
                              }
                            },
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
                            value: tracking.location!,
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
            padding: EdgeInsets.only(
              bottom: isLast
                  ? DimensionsResources.D_0
                  : DimensionsResources.D_25.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}