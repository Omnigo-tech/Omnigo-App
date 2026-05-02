import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/sizes.dart';
import 'package:grocery_app/data/models/address.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final addressController = TextEditingController();
  final zipController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  bool saveAddress = false;
  String country = "Pakistan";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Checkout",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Column(
          children: [
            Card(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 0,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.sp,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 50.w),
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 3.w,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2.h,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(width: 50.w),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Shipping Address",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Payment Method",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Text(
                        "Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),

                      AuthTextField(
                        label: "",
                        controller: addressController,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Zip Code",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 6.h),
                                AuthTextField(
                                  label: "",
                                  keyboardType: TextInputType.number,
                                  controller: zipController,
                                  validator: (v) => v == null || v.isEmpty
                                      ? "Required"
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "City",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 6.h),
                                AuthTextField(
                                  label: "",
                                  controller: cityController,
                                  validator: (v) => v == null || v.isEmpty
                                      ? "Required"
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      const Text(
                        "Phone",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),

                      AuthTextField(
                        label: "+92",
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        validator: (v) => v == null || v.isEmpty
                            ? "Required"
                            : v.length > 11 || v.length < 11
                            ? "Minimum 11 digit required"
                            : null,
                      ),

                      SizedBox(height: 16.h),

                      const Text(
                        "Country",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButton<String>(
                          value: country,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: ["Pakistan", "UAE", "India"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() => country = val!);
                          },
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                saveAddress = !saveAddress;
                              });
                            },
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: saveAddress
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 2.w,
                                ),
                                color: saveAddress
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                              child: saveAddress
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          const Text("Save shipping address"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: AuthButton(text: "NEXT", onTap: _submit),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = AddressModel(
      locationname: "New Address",
      username: "User",
      phone: phoneController.text,
      address: "${addressController.text}, ${cityController.text}, $country",
    );

    context.read<AddressBloc>().add(AddAddressEvent(newAddress, saveAddress));

    Navigator.pop(context);
  }
}
