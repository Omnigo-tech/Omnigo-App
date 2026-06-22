import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/dimensions-resource.dart';
import '../../../core/helper/constants/strings-resource.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../widgets/cutom_button.dart';
import '../../bloc/onboarding/onboarding_bloc.dart';
import '../../bloc/onboarding/onboarding_event.dart';
import '../../bloc/onboarding/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingBloc>()..add(GetOnboardingDataEvent()),
      child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              );
            }

            if (state is OnboardingFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            if (state is OnboardingSuccess) {
              final onboardingList = state.onboardingData;
              return Stack(
                children: [
                  // DYNAMIC CONTENT (PageView)
                  PageView.builder(
                    controller: _pageController,

                    itemCount: onboardingList.length,
                    physics: const NeverScrollableScrollPhysics(),

                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },

                    itemBuilder: (context, index) {
                      final item = onboardingList[index];

                      return Column(
                        children: [
                          SizedBox(height: 140.h),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DimensionsResources.D_20.sp,
                            ),

                            child: Container(
                              height: 320.h,

                              width: double.infinity,

                              alignment: Alignment.center,

                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl,

                                fit: BoxFit.contain,

                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                ),

                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.fastfood,

                                      size: 100,

                                      color: AppColors.white,
                                    ),
                              ),
                            ),
                          ),

                          SizedBox(height: DimensionsResources.D_40.h),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DimensionsResources.D_20.sp,
                            ),

                            child: Text(
                              item.title,

                              textAlign: TextAlign.center,

                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontFamily: GoogleFonts.inter().fontFamily,

                                    fontSize: DimensionsResources
                                        .FONT_SIZE_2X_EXTRA_MEDIUM
                                        .sp,

                                    color: AppColors.white,

                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),

                          SizedBox(height: DimensionsResources.D_20.h),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DimensionsResources.D_20.sp,
                            ),

                            child: Text(
                              item.description,

                              textAlign: TextAlign.center,

                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontFamily: GoogleFonts.inter().fontFamily,

                                    fontSize:
                                        DimensionsResources.FONT_SIZE_SMALL.sp,

                                    color: AppColors.white.withValues(
                                      alpha: 0.8,
                                    ),

                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // STATIC TOP BAR
                  Positioned(
                    top: 0,

                    left: 0,

                    right: 0,

                    child: Container(
                      width: double.infinity,

                      height: 110.h,

                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,

                          end: Alignment.bottomCenter,

                          colors: [
                            AppColors.lightBlueBackground,

                            Color(0xFFB4D1E6),

                            Color(0xFF0264D3),
                          ],

                          stops: [0.0, 0.4, 1.0],
                        ),
                      ),

                      child: Padding(
                        padding: EdgeInsets.only(
                          left: DimensionsResources.D_20.sp,

                          right: DimensionsResources.D_20.sp,

                          top: DimensionsResources.D_50.sp,
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              StringResources.omnigo,

                              style: TextStyle(
                                color: AppColors.white,

                                fontSize: DimensionsResources
                                    .FONT_SIZE_2X_EXTRA_MEDIUM
                                    .sp,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (_currentIndex != onboardingList.length - 1)
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.welcome,
                                  );
                                },

                                child: Text(
                                  StringResources.skip,

                                  style: TextStyle(
                                    color: AppColors.white,

                                    fontSize:
                                        DimensionsResources.FONT_SIZE_SMALL.sp,

                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // STATIC BOTTOM COMPONENTS
                  Positioned(
                    bottom: DimensionsResources.D_80.h,

                    left: DimensionsResources.D_20.sp,

                    right: DimensionsResources.D_20.sp,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: List.generate(
                            onboardingList.length,

                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),

                              height: 8.h,

                              width: _currentIndex == index ? 24.w : 8.w,

                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? AppColors.white
                                    : AppColors.white.withValues(alpha: 0.4),

                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: DimensionsResources.D_30.h),

                        // Dynamic Next Button
                        CustomButton(
                          text: _currentIndex == onboardingList.length - 1
                              ? "GET STARTED"
                              : StringResources.next,

                          color: AppColors.homeBackground,

                          borderColor: AppColors.white,

                          textColor: AppColors.white,

                          borderRadius: DimensionsResources.D_30.r,

                          onClick: () {
                            if (_currentIndex == onboardingList.length - 1) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.welcome,
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),

                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
