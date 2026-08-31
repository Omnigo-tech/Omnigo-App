import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/data/models/grocery-item.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';

import '../../../../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../../../../core/helper/utils/phone_formatter.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../widgets/app_bar_widget.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../../../bloc/grocery_details/grocery_ui_effect.dart';
import '../../../bloc/grocery_details/item_detail_event.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<GroceryItemModel> selectedItems = [];

  @override
  void initState() {
    super.initState();

    final bloc = context.read<GroceryDetailBloc>();

    bloc.add(LoadFavoritesEvent());

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: CustomAppBar(
        title: StringResources.favourite,
        showBackButton: true,
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.groceryhome,
            arguments: StringResources.vegetables,
          );
        },
      ),

      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          if (state.isFavoritesLoading) {
            return const Center(child: SpinKitThreeInOut(
              color: AppColors.primary,
              size: DimensionsResources.FONT_SIZE_EXTRA_EXTRA_LARGE,
            ));
          }
          final favList = state.favorites;

          if (favList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: DimensionsResources.D_80.sp,
                    color: AppColors.grey,
                  ),
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
            separatorBuilder: (_, __) => Divider(
              color: AppColors.border,
              indent: DimensionsResources.D_16.w,
              endIndent: DimensionsResources.D_16.w,
            ),
            itemBuilder: (context, index) {
              final item = favList[index];
              final isInCart = state.cart.any((e) => e.id == item.id);
              return Dismissible(
                key: Key(item.id.toString()),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  if (selectedItems.contains(item)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Unselect item first before deleting"),
                        backgroundColor: AppColors.red,
                      ),
                    );
                    return false;
                  }
                  return true;
                },
                onDismissed: (_) {
                  setState(() {
                    selectedItems.remove(item);
                  });
                  context.read<GroceryDetailBloc>().add(
                    RemoveFavoriteEvent(item.id),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(
                    horizontal: DimensionsResources.D_20.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(
                      DimensionsResources.D_12.r,
                    ),
                  ),
                  child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
                ),
                child: ListTile(
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isInCart
                            ? true
                            : selectedItems.contains(item),

                        activeColor: AppColors.primary,

                        onChanged: isInCart
                            ? null
                            : (value) {
                          setState(() {
                            if (value == true) {
                              selectedItems.add(item);
                            } else {
                              selectedItems.remove(item);
                            }
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      Image.network(
                        ImageUrl.fixImageUrl(item.image),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      )
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
                    "${item.weight ?? ''}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Text(
                        "Rs. ${item.price}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      if (isInCart)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            "Added",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        )
                      else
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.black,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(DimensionsResources.D_24.w),
          child: GestureDetector(
            onTap: () {

              if (selectedItems.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<GroceryDetailBloc>(),
                      child: const MyCartScreen(),
                    ),
                  ),
                );
                return;
              }

              final bloc = context.read<GroceryDetailBloc>();

              final itemsToAdd = selectedItems.where((item) {
                return !bloc.state.cart.any((e) => e.id == item.id);
              }).toList();

              if (itemsToAdd.isEmpty) {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const MyCartScreen(),
                    ),
                  ),
                );

                return;
              }
              bloc.add(
                AddToCartEvent.multiple(itemsToAdd),
              );
              setState(() {
                selectedItems.clear();
              });

            },
            child: Container(
              height: 55.h,
              decoration: BoxDecoration(
                color: selectedItems.isEmpty
                    ? AppColors.grey
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Stack(
                      children: [
                        const Icon(Icons.shopping_cart, color: Colors.white),
                        if (selectedItems.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                selectedItems.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Text(
                    selectedItems.isEmpty
                        ? "View Cart"
                        : "Add ${selectedItems.length} Item${selectedItems.length > 1 ? "s" : ""}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(width: 40.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
