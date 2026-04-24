import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import 'package:grocery_app/widgets/cutom_button.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          StringResources.favourite,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final favList = state.items.where((item) => item.isFavorite).toList();

          if (favList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: DimensionsResources.D_80.sp, color: AppColors.grey),
                  SizedBox(height: DimensionsResources.D_16.h),
                  Text(
                    StringResources.noFavoritesYet,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_10.h),
            itemCount: favList.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.border,
              indent: DimensionsResources.D_16.w,
              endIndent: DimensionsResources.D_16.w,
            ),
            itemBuilder: (context, index) {
              final item = favList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<GroceryDetailBloc>(),
                        child: DetailScreen(item: item),
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: index % 2 == 0
                              ? Colors.green
                              : AppColors.grey.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: index % 2 == 0
                          ? Center(
                              child: Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Image.asset(
                      item.image,
                      width: 50.w,
                      height: 50.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                title: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                ),
                subtitle: Text(
                  "${item.weight ?? ''}, Price",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rs. ${item.price}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.black),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(DimensionsResources.D_24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                onClick: () {
                },
                text: StringResources.addAllToCart,
                textColor: AppColors.white,
                borderRadius: DimensionsResources.D_19.r,
              ),
              SizedBox(height: DimensionsResources.D_12.h),
              CustomButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<GroceryDetailBloc>(),
                        child: const MyCartScreen(),
                      ),
                    ),
                  );
                },
                text: StringResources.goToCart,
                textColor: AppColors.white,
                borderRadius: DimensionsResources.D_19.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
