import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
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
import '../../../../core/helper/utils/phone_formatter.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../widgets/confirm_order.dart';
import '../../../../widgets/cutom_button.dart';

class CheckoutSummaryScreen extends StatefulWidget {
  final String? selectedMethod;

  const CheckoutSummaryScreen({super.key, required this.selectedMethod});

  @override
  State<CheckoutSummaryScreen> createState() => _CheckoutSummaryScreenState();
}

class _CheckoutSummaryScreenState extends State<CheckoutSummaryScreen> {
  late String currentMethod;

  @override
  void initState() {
    super.initState();
    currentMethod =
        (widget.selectedMethod == null || widget.selectedMethod!.isEmpty)
        ? "cash_on_delivery"
        : widget.selectedMethod!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: const CustomAppBar(title: StringResources.checkoutSummary),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final cartList = state.cart;

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
                        Text(
                          "Delivery Address",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                                                "Select Address",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(address?.address ?? ""),
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
                        SizedBox(height: 15.h),
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
                                const Text(
                                  "Add new address",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "Products in Cart",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                                    Container(
                                      width: 60.w,
                                      height: 60.h,
                                      child:  Image.network(
                                        ImageUrl.fixImageUrl(item.image),
                                        width: 50.w,
                                        height: 50.h,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(
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
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item.weight ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            "\$${item.price}",
                                            style: GoogleFonts.dmSans(
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
                                        Text(item.quantity.toString()),
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
                        Text(
                          "Payment Method",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    Text(
                                      currentMethod,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Navigating to payment method screen to change selection
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.paymentmethodScreen,
                                    arguments: {'isChange': true},
                                  );

                                  // Update UI with new selection if returned
                                  if (result != null && result is String) {
                                    setState(() {
                                      currentMethod = result;
                                    });
                                  }
                                },
                                child: Text(
                                  "change",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "Bill Details",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                              _billRow("Subtotal", subtotal),
                              _billRow("Delivery Fee", deliveryFee),
                              _billRow("Tax & Other Fees", tax),
                              const Divider(),
                              _billRow("Total", total, isBold: true),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
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
                                child: const Text("Add Promo"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.homeBackground,
                              ),
                              child: const Text("Apply"),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(DimensionsResources.D_16.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: DimensionsResources.D_50.h,
                    child: BlocConsumer<GroceryDetailBloc, GroceryDetailState>(
                      listener: (context, state) {
                        if (state.message == "Order placed successfully") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfirmOrder(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final address = context
                            .read<AddressBloc>()
                            .state
                            .selectedAddress;
                        return CustomButton(
                          text: "Confirm Your Order",
                          isLoading: state.isOrderLoading,
                          onClick: state.isOrderLoading
                              ? null
                              : () {
                                  context.read<GroceryDetailBloc>().add(
                                    PlaceOrderEvent(address!, currentMethod),
                                  );
                                },
                          color: AppColors.homeBackground,
                          textColor: AppColors.white,
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

  Widget _billRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
