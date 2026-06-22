import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/add_address_screen.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import '../../../../core/helper/constants/strings-resource.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: StringResources.addressDetail,
        showBackButton: true,
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state.addresses.isEmpty) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off_outlined, size: 60.sp, color: Colors.grey),
                    SizedBox(height: 10.h),
                    const Text("No addresses found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    SizedBox(height: 20.h),
                    _buildAddAddressButton(context),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: state.addresses.length + 1,
              itemBuilder: (context, index) {
                if (index != state.addresses.length) {
                  final item = state.addresses[index];
                  final isSelected = state.selectedAddress?.id == item.id; // Safe ID comparison

                  return Card(
                    color: AppColors.white,
                    margin: EdgeInsets.only(bottom: 12.h),
                    elevation: isSelected ? 2 : 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : Colors.grey.shade200,
                        width: isSelected ? 1.5.w : 1.w,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        context.read<AddressBloc>().add(SelectAddressEvent(item));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(14.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: isSelected ? AppColors.primary : Colors.grey,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      item.locationname,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.grey),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<AddressBloc>(),
                                              child: AddAddressScreen(existingAddress: item),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () {
                                        // Directly pass unique server database ID
                                        context.read<AddressBloc>().add(DeleteAddressEvent(item.id));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Divider(),
                            SizedBox(height: 4.h),
                            Text("Receiver: ${item.username}", style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp)),
                            SizedBox(height: 2.h),
                            Text("Phone: ${item.phone}", style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp)),
                            SizedBox(height: 2.h),
                            Text("Address: ${item.address}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: _buildAddAddressButton(context),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddAddressButton(BuildContext context) {
    return Center(
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
              radius: 22.r,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.add, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              "Add new address",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}