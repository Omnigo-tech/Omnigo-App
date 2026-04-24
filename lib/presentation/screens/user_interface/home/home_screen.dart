import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/widgets/header_widget.dart';

import '../../../../core/helper/constants/dimensions-resource.dart';
import '../../../../core/helper/constants/images-resources.dart';
import '../../../../core/helper/constants/strings-resource.dart';
import '../../../../widgets/categories_widget.dart';
import '../../../../widgets/promo_section_widget.dart';
import '../../../../widgets/vehicle_services_widget.dart';
import '../../../bloc/home/home_bloc.dart';
import '../../../bloc/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: AppColors.homeBackground,
      child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
      
            if (state is HomeLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const HeaderWidget(),
                    SizedBox(height: DimensionsResources.D_30.h),
                    Transform.translate(
                      offset: Offset(0, -DimensionsResources.D_20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DimensionsResources.D_4.sp,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(DimensionsResources.D_16),
                          decoration: BoxDecoration(
                            color: AppColors.whiteTranslucent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                DimensionsResources.D_25.r,
                              ),
                              topLeft: Radius.circular(
                                DimensionsResources.D_25.r,
                              ),
                            ),
                            boxShadow: const [
                              BoxShadow(blurRadius: 10, color: Colors.black12),
                            ],
                          ),
                          child: Column(
                            children: [
                              _locationCard(),
                              SizedBox(height: DimensionsResources.D_20.h),
                              VehicleServicesWidget(services: state.services),
                              SizedBox(height: DimensionsResources.D_20.h),
                              CarouselSlider.builder(
                                itemCount: ImageResource.banners.length,
                                itemBuilder: (context, index, realIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      DimensionsResources.D_10.r,
                                    ),
                                    child: Image.asset(
                                      ImageResource.banners[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: DimensionsResources.D_200.h,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  enlargeCenterPage: false,
                                  viewportFraction: 1.0,
                                  aspectRatio: 16 / 9,
                                  initialPage: DimensionsResources.INT_0,
                                ),
                              ),
      
                              SizedBox(height: DimensionsResources.D_10.h),
      
                              CategoriesWidget(categories: state.categories),
      
                              Padding(
                                padding: EdgeInsets.only(
                                  top: DimensionsResources.D_20.h,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    DimensionsResources.RADIUS_DEFAULT.r,
                                  ),
                                  child: Image.asset(
                                    ImageResource.BANNER_IMAGE1,
                                    height: DimensionsResources.D_180.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
      
                    const PromoSection(),
                  ],
                ),
              );
            }
      
            return const SizedBox();
          },
        ),
    );
  }

  Widget _locationCard() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.primary),

        SizedBox(width: DimensionsResources.D_10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringResources.yourLocation,
                style: GoogleFonts.poppins(
                  fontSize: DimensionsResources.FONT_SIZE_2X_EXTRA_SMALL.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                StringResources.locationAddress,
                style: GoogleFonts.poppins(
                  fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const Icon(
          Icons.arrow_forward_ios,
          size: DimensionsResources.FONT_SIZE_MEDIUM,
        ),
      ],
    );
  }
}
