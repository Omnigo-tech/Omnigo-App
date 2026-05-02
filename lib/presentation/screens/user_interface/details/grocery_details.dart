import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/data/models/grocery-item.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import 'package:grocery_app/widgets/cutom_button.dart';

import '../../../../core/helper/constants/colors_resources.dart';
import '../../../../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../../../../widgets/circle_button_widget.dart';
import '../../../../widgets/info_glosery_card_widget.dart';
import '../../../bloc/grocery_details/item_detail_bloc.dart';
import '../../../bloc/grocery_details/item_detail_event.dart';
import '../../../bloc/grocery_details/item_detail_state.dart';
import '../../../../core/routes/AppRoutes.dart';

class DetailScreen extends StatelessWidget {
  final GroceryItemModel item;

  const DetailScreen({super.key, required this.item});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
      builder: (context, state) {
        final currentItem = state.items.isNotEmpty
            ? state.items.firstWhere(
              (e) => e.id == item.id,
          orElse: () => item,
        )
            : item;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: DimensionsResources.D_276.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.itemBackground,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width,
                            DimensionsResources.D_100,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          currentItem.image,
                          height: DimensionsResources.D_180.h,
                        ),
                      ),
                    ),

                    // Back Button
                    Positioned(
                      top: DimensionsResources.D_15,
                      left: DimensionsResources.D_15,
                      child: CircleAvatar(
                        backgroundColor: AppColors.white,
                        child: IconButton(
                          onPressed: ()=>Navigator.pop(context),
                          icon: SvgPicture.asset(
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

                    // Favorite Button
                    Positioned(
                      top: DimensionsResources.D_15,
                      right: DimensionsResources.D_15,
                      child: GestureDetector(
                        onTap: () {
                          context.read<GroceryDetailBloc>().add(
                            ToggleFavoriteEvent(currentItem.id),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.white,
                          child: Icon(
                            currentItem.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                      EdgeInsets.all(DimensionsResources.D_20.sp),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentItem.name,
                                style: GoogleFonts.dmSans(
                                  fontSize: DimensionsResources
                                      .FONT_SIZE_EXTRA_LARGE.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                width: DimensionsResources.D_100.w,
                                height:
                                DimensionsResources.D_40.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                    DimensionsResources
                                        .RADIUS_SMALL.r,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    CustomCircleBtn(
                                      icon: Icons.remove,
                                      isAdd: false,
                                      size:
                                      DimensionsResources.D_32,
                                      borderRadius:
                                      DimensionsResources
                                          .D_16,
                                      onTap: () {
                                        context
                                            .read<
                                            GroceryDetailBloc>()
                                            .add(
                                          DecrementQtyEvent(
                                              currentItem.id),
                                        );
                                      },
                                    ),
                                    Text(
                                      currentItem.quantity
                                          .toString(),
                                      style:
                                      GoogleFonts.dmSans(
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),
                                    CustomCircleBtn(
                                      icon: Icons.add,
                                      isAdd: true,
                                      size:
                                      DimensionsResources.D_32,
                                      borderRadius:
                                      DimensionsResources
                                          .D_16,
                                      onTap: () {
                                        context
                                            .read<
                                            GroceryDetailBloc>()
                                            .add(
                                          IncrementQtyEvent(
                                              currentItem.id),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          SizedBox(height: 8.h),

                          Text(
                            currentItem.weight ?? '',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          Text(
                            currentItem.description,
                            style: GoogleFonts.dmSans(
                              color: AppColors.grey,
                            ),
                          ),

                          SizedBox(height: 20.h),

                          Row(
                            children: [
                              Expanded(
                                child: InfoGloseryCardWidget(
                                  image: ImageResource.ORGANIC,
                                  title: "100%",
                                  subtitle:
                                  StringResources.organic,
                                ),
                              ),
                              Expanded(
                                child: InfoGloseryCardWidget(
                                  image:
                                  ImageResource.CALENDER,
                                  title: "1 Year",
                                  subtitle: StringResources
                                      .expiration,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          Row(
                            children: [
                              Expanded(
                                child: InfoGloseryCardWidget(
                                  image: ImageResource.RATING,
                                  title: "4.8",
                                  subtitle: StringResources
                                      .reviews,
                                ),
                              ),
                              Expanded(
                                child: InfoGloseryCardWidget(
                                  image: ImageResource.KACL,
                                  title: "80 kcal",
                                  subtitle: "100 Gram",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: DimensionsResources.D_60.h),
                Padding(
                  padding: EdgeInsets.all(DimensionsResources.D_16.w),
                  child: CustomButton(
                    onClick: () {
                      context.read<GroceryDetailBloc>().add(
                        AddToCartEvent(currentItem),
                      );
                      GlobalDialogs.showAddedToCartDialog(
                        context,
                        selectedItems: [currentItem],
                      );
                    },
                    text: StringResources.addToCart,
                    textColor: AppColors.white,
                    borderRadius: DimensionsResources.D_50.r,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
