import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/add_address_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/address_screen.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import 'package:grocery_app/widgets/circle_button_widget.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helper/utils/phone_formatter.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../data/datasource/local/auth_local_data_source.dart';
import '../../../../widgets/confirm_order.dart';
import '../../../../widgets/cutom_button.dart';
import '../../../bloc/grocery_details/grocery_ui_effect.dart';

class CheckoutSummaryScreen extends StatefulWidget {
  final String? selectedMethod;

  const CheckoutSummaryScreen({super.key, required this.selectedMethod});

  @override
  State<CheckoutSummaryScreen> createState() => _CheckoutSummaryScreenState();
}

class _CheckoutSummaryScreenState extends State<CheckoutSummaryScreen> {
  late String currentMethod;
  late StreamSubscription subscription;

  // Drop-off Preferences State Variables
  String selectedDropOff = "Hand it to me";
  final TextEditingController instructionsController = TextEditingController();

  final List<Map<String, String>> dropOffOptions = [
    {"title": "Hand it to me", "icon": ImageResource.HAND_DROP},
    {"title": "Meet at my door", "icon": ImageResource.MEET_DOOR_DROP},
    {"title": "Meet Outside", "icon": ImageResource.OUTSIDE_DROP},
    {"title": "Leave at my door", "icon": ImageResource.LEAVE_DOOR_DROP},
  ];

  @override
  void initState() {
    super.initState();

    currentMethod =
    widget.selectedMethod?.isNotEmpty == true
        ? widget.selectedMethod!
        : "cash_on_delivery";

    subscription = context
        .read<GroceryDetailBloc>()
        .effectStream
        .listen((effect) {

      if (effect is OrderPlacedEffect) {
        final userId = sl<AuthLocalDataSource>().getUserId();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmOrder(
              orderId: effect.orderId,
              userId: userId!,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: const CustomAppBar(title: StringResources.checkoutSummary),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final cartList = state.cart;
          final localData = sl<AuthLocalDataSource>().getUserLocation();
          String currentAddress = localData?['address'] ?? '';
          String id = localData?['id'] ?? '';

          double subtotal = 0;
          for (var item in cartList) {
            subtotal += item.price * item.quantity;
          }

          const deliveryFee = 6.0;
          const tax = 2.5;
          final total = subtotal + deliveryFee + tax;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- DELIVERY ADDRESS SECTION ---
                        Text(
                          "Delivery Address",
                          style: textTheme.titleMedium,
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<AddressBloc, AddressState>(
                          builder: (context, state) {
                            final address = state.selectedAddress;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<AddressBloc>(),
                                      child: const AddressListScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address?.locationname ??
                                                "Saved Address",
                                            style: textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            address?.address ?? currentAddress,
                                            style: textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<AddressBloc>(),
                                    child: const AddAddressScreen(),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor: AppColors.border,
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "Add new address",
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // --- DROP-OFF OPTIONS ---
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 2.h,
                              ),
                              childrenPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              title: Text(
                                "Drop-off Options: $selectedDropOff",
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(color: AppColors.border),
                                    ...dropOffOptions.map((option) {
                                      final isSelected =
                                          selectedDropOff == option["title"];
                                      return RadioListTile<String>(
                                        value: option["title"]!,
                                        groupValue: selectedDropOff,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppColors.primary,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              option["icon"]!,
                                              width: 20.w,
                                              height: 20.h,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              option["title"]!,
                                              style: textTheme.bodyMedium?.copyWith(
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedDropOff = value;
                                            });
                                          }
                                        },
                                      );
                                    }).toList(),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "Instructions for delivery person",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    TextField(
                                      controller: instructionsController,
                                      style: textTheme.bodyMedium,
                                      decoration: InputDecoration(
                                        hintText:
                                        "Example: Please knock instead of using door bell",
                                        hintStyle: textTheme.bodySmall,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.r),
                                          borderSide: const BorderSide(
                                            color: AppColors.border,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.r),
                                          borderSide: const BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // --- PRODUCTS IN CART SECTION ---
                        Text(
                          "Products in Cart",
                          style: textTheme.titleMedium,
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartList.length,
                            separatorBuilder: (_, _) =>
                            const Divider(color: AppColors.border),
                            itemBuilder: (context, index) {
                              final item = cartList[index];

                              return Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 60.w,
                                      height: 60.h,
                                      child: Image.network(
                                        ImageUrl.fixImageUrl(item.image),
                                        width: 50.w,
                                        height: 50.h,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                        const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item.weight ?? '',
                                            style: textTheme.bodySmall,
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            "\$${item.price}",
                                            style: textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CustomCircleBtn(
                                          icon: Icons.remove,
                                          isAdd: false,
                                          size: 30,
                                          borderRadius: 10,
                                          onTap: () {
                                            context
                                                .read<GroceryDetailBloc>()
                                                .add(
                                              DecrementQtyEvent(item.id),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          item.quantity.toString(),
                                          style: textTheme.bodyMedium,
                                        ),
                                        SizedBox(width: 8.w),
                                        CustomCircleBtn(
                                          icon: Icons.add,
                                          isAdd: true,
                                          size: 30,
                                          borderRadius: 10,
                                          onTap: () {
                                            context
                                                .read<GroceryDetailBloc>()
                                                .add(
                                              IncrementQtyEvent(item.id),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 15.h),

                        // --- PAYMENT METHOD SECTION ---
                        Text(
                          "Payment Method",
                          style: textTheme.titleMedium,
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.money,
                                  color: Colors.green.shade400,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pay via",
                                      style: textTheme.bodySmall,
                                    ),
                                    Text(
                                      currentMethod,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.paymentmethodScreen,
                                    arguments: {'isChange': true},
                                  );

                                  if (result != null && result is String) {
                                    setState(() {
                                      currentMethod = result;
                                    });
                                  }
                                },
                                child: Text(
                                  "change",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // --- BILL DETAILS SECTION ---
                        Text(
                          "Bill Details",
                          style: textTheme.titleMedium,
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            children: [
                              _billRow(context, "Subtotal", subtotal),
                              _billRow(context, "Delivery Fee", deliveryFee),
                              _billRow(context, "Tax & Other Fees", tax),
                              const Divider(),
                              _billRow(context, "Total", total, isBold: true),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),

                        // --- PROMO CODE SECTION ---
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Add Promo",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.homeBackground,
                              ),
                              child: Text(
                                "Apply",
                                style: textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),

                // --- CONFIRM ORDER BUTTON ---
                Container(
                  padding: EdgeInsets.all(DimensionsResources.D_16.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: DimensionsResources.D_50.h,
                    child: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
                      builder: (context, state) {
                        final address =
                            context.watch<AddressBloc>().state.selectedAddress;

                        return CustomButton(
                          text: "Confirm Your Order",
                          textColor: AppColors.white,
                          isLoading: state.isOrderLoading,
                          onClick: state.isOrderLoading
                              ? null
                              : () {
                            print("*********${selectedDropOff}******");
                            print("*********${instructionsController.text}******");
                            context.read<GroceryDetailBloc>().add(
                              PlaceOrderEvent(
                                address?.id ?? id,
                                currentMethod,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _billRow(BuildContext context, String title, double value, {bool isBold = false}) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold
                ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                : textTheme.bodyMedium,
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: isBold
                ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                : textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}