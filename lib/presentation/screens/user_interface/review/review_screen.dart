import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import 'package:grocery_app/widgets/cutom_button.dart';

import '../../../../core/helper/constants/images-resources.dart';
import '../../../../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../data/models/review_model.dart';
import '../../../bloc/review/review_bloc.dart';
import '../../../bloc/review/review_event.dart';
import '../../../bloc/review/review_state.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch reviews from API on screen load
    context.read<ReviewBloc>().add(FetchReviewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: StringResources.omnigo,
        showBackButton: true,
        onTap: () => Navigator.pop(context),
      ),
      body: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          // Show success dialog after submit
          if (state is ReviewSubmitSuccess) {
            GlobalDialogs.showStatusDialog(
              context: context,
              isSuccess: true,
              imagePath: ImageResource.REVIEW_DONE,
              title: StringResources.thanksForFeedback,
              subtitle: StringResources.feedbackSubtitle,
              primaryButtonText: StringResources.backToHome,
              onPrimaryClick: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
            );
          }

          // Show error snackbar if submit fails
          if (state is ReviewSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            // Show loader while fetching
            if (state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show submitting state (keep showing reviews with loader overlay)
            if (state is ReviewSubmitting) {
              return Stack(
                children: [
                  _buildBody(
                    context,
                    state.currentReviews,
                    averageRating: 0,
                    ratingCounts: {},
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }

            // Show error state
            if (state is ReviewError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ReviewBloc>().add(FetchReviewsEvent()),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            // Show loaded reviews
            if (state is ReviewLoaded) {
              if (state.reviews.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildBody(
                context,
                state.reviews,
                averageRating: state.averageRating,
                ratingCounts: state.ratingCounts,
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // Main body with reviews
  Widget _buildBody(
    BuildContext context,
    List<ReviewModel> reviews, {
    required double averageRating,
    required Map<int, int> ratingCounts,
  }) {
    final total = reviews.length;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: DimensionsResources.D_10.h),
              // Summary with real data
              _buildHeaderSummary(
                context,
                averageRating: averageRating,
                ratingCounts: ratingCounts,
                total: total,
              ),
              SizedBox(height: DimensionsResources.D_20.h),
              _buildReviewList(reviews),
              SizedBox(height: 100.h), // space for sticky button
            ],
          ),
        ),
        _buildStickyButton(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: DimensionsResources.D_50.h),
              Image.asset(
                ImageResource.NO_REVIEW_IMG,
                height: DimensionsResources.D_180.h,
              ),
              SizedBox(height: DimensionsResources.D_30.h),
              Text(
                StringResources.noReviewsYet,
                style: GoogleFonts.inter(
                  fontSize: DimensionsResources.D_20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: DimensionsResources.D_8.h),
              Text(
                StringResources.waitingForFirstFeedback,
                style: GoogleFonts.inter(
                  fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        _buildStickyButton(context),
      ],
    );
  }

  // Header summary now uses real averageRating, ratingCounts, total
  Widget _buildHeaderSummary(
    BuildContext context, {
    required double averageRating,
    required Map<int, int> ratingCounts,
    required int total,
  }) {
    final avgRounded = averageRating.round().clamp(0, 5);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DimensionsResources.D_10),
        color: AppColors.lightBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(DimensionsResources.D_20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Progress bars from real ratingCounts
            Expanded(
              flex: DimensionsResources.INT_3,
              child: Column(
                children: [5, 4, 3, 2, 1].map((star) {
                  final count = ratingCounts[star] ?? 0;
                  final progress = total > 0 ? count / total : 0.0;
                  return _buildProgressBar(star, progress);
                }).toList(),
              ),
            ),
            SizedBox(width: DimensionsResources.D_30.w),
            // Average rating from real data
            Expanded(
              flex: DimensionsResources.INT_2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: GoogleFonts.mulish(
                      fontSize: DimensionsResources.D_46.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      DimensionsResources.INT_5,
                      (i) => Padding(
                        padding: EdgeInsets.only(
                          right: DimensionsResources.D_5.w,
                        ),
                        child: SvgPicture.asset(
                          i < avgRounded
                              ? ImageResource.SELECT_STAR_ICON
                              : ImageResource.UNSELECT_STAR_ICON,
                          width: DimensionsResources.D_14.w,
                          height: DimensionsResources.D_14.h,
                          colorFilter: ColorFilter.mode(
                            i < avgRounded ? AppColors.amber : AppColors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_10.h),
                  // Real total review count
                  Text(
                    "$total ${StringResources.totalReviews}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkSecondary,
                      fontSize: DimensionsResources.D_14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int label, double val) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_2.h),
      child: Row(
        children: [
          Text(
            "$label",
            style: GoogleFonts.mulish(
              fontSize: DimensionsResources.FONT_SIZE_1X_EXTRA_MEDIUM.sp,
            ),
          ),
          SizedBox(width: DimensionsResources.D_10.w),
          SvgPicture.asset(
            ImageResource.SELECT_STAR_ICON,
            width: DimensionsResources.D_16.w,
            height: DimensionsResources.D_16.h,
            colorFilter: const ColorFilter.mode(
              AppColors.amber,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: DimensionsResources.D_10.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DimensionsResources.D_10),
              child: LinearProgressIndicator(
                value: val,
                minHeight: DimensionsResources.D_6.h,
                backgroundColor: AppColors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList(List<ReviewModel> reviews) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) =>
          Divider(color: AppColors.grey, height: DimensionsResources.D_40.h),
      itemBuilder: (context, index) {
        final item = reviews[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Real user image from API with fallback avatar
                CircleAvatar(
                  radius: DimensionsResources.D_20.r,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage(item.userImg),
                  onBackgroundImageError: (_, __) {},
                  child: item.userImg.isEmpty
                      ? Text(
                          item.userName.isNotEmpty
                              ? item.userName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                SizedBox(width: DimensionsResources.D_12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Real user name from API
                      Text(
                        item.userName,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: DimensionsResources.D_14.sp,
                        ),
                      ),
                      Row(
                        children: [
                          // Real rating from API
                          ...List.generate(
                            DimensionsResources.INT_5,
                            (i) => Padding(
                              padding: EdgeInsets.only(
                                right: DimensionsResources.D_4.w,
                              ),
                              child: SvgPicture.asset(
                                ImageResource.SELECT_STAR_ICON,
                                width: DimensionsResources.D_14.w,
                                height: DimensionsResources.D_14.h,
                                colorFilter: ColorFilter.mode(
                                  i < item.rating
                                      ? AppColors.amber
                                      : AppColors.grey,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: DimensionsResources.D_8.w),
                          // timeAgo calculated from createdAt
                          Text(
                            item.timeAgo,
                            style: TextStyle(
                              fontSize: DimensionsResources.D_14.sp,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppColors.grey),
              ],
            ),
            SizedBox(height: DimensionsResources.D_12.h),
            // Real comment from API
            Text(
              item.comment,
              style: GoogleFonts.mulish(
                fontSize: DimensionsResources.D_14.sp,
                color: AppColors.black,
                height: DimensionsResources.D_1.h,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStickyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: DimensionsResources.D_50.w),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(DimensionsResources.D_10.w),
          child: CustomButton(
            onClick: () => _showAddReviewSheet(context),
            text: StringResources.writeReview,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }

  void _showAddReviewSheet(BuildContext screenContext) {
    final reviewBloc = BlocProvider.of<ReviewBloc>(screenContext);
    final TextEditingController controller = TextEditingController();
    double userRating = 0;

    showModalBottomSheet(
      context: screenContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DimensionsResources.D_25.r),
        ),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: reviewBloc,
        child: StatefulBuilder(
          builder: (stateContext, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              left: DimensionsResources.D_20,
              right: DimensionsResources.D_20,
              top: DimensionsResources.D_20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(
                        DimensionsResources.D_10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    StringResources.rateYourExperience,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: DimensionsResources.D_20),
                  // Star rating selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DimensionsResources.D_15.w,
                        ),
                        child: GestureDetector(
                          onTap: () => setSheetState(
                            () => userRating = (index + 1).toDouble(),
                          ),
                          child: SvgPicture.asset(
                            index < userRating
                                ? ImageResource.SELECT_STAR_ICON
                                : ImageResource.UNSELECT_STAR_ICON,
                            width: DimensionsResources.D_30.w,
                            height: DimensionsResources.D_30.h,
                            colorFilter: ColorFilter.mode(
                              index < userRating
                                  ? AppColors.amber
                                  : AppColors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: DimensionsResources.D_20.h),
                  // Review text field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: controller,
                        maxLines: 4,
                        maxLength: 200,
                        onChanged: (_) => setSheetState(() {}),
                        decoration: InputDecoration(
                          hintText: StringResources.shareYourExperience,
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          counterText:
                              "${controller.text.length}/200 ${StringResources.letters}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Submit button — calls API via bloc
                  CustomButton(
                    onClick: () {
                      if (controller.text.isNotEmpty && userRating > 0) {
                        // Close sheet first
                        Navigator.pop(sheetContext);

                        // Dispatch AddReviewEvent with rating + message
                        // Bloc will POST to API then refetch all reviews
                        reviewBloc.add(
                          AddReviewEvent(
                            rating: userRating,
                            message: controller.text,
                          ),
                        );
                      } else {
                        // Show validation hint
                        ScaffoldMessenger.of(screenContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select a rating and write a review",
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    text: StringResources.submitReview,
                    textColor: AppColors.white,
                  ),
                  SizedBox(height: DimensionsResources.D_50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
