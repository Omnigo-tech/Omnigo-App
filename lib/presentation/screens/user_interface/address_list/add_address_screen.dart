import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/sizes.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/data/models/address.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';
import '../../../../core/helper/extension/payment_extention.dart';
import '../../../bloc/address/address_state.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressModel? existingAddress; // Index hata diya, existingAddress hi kafi hai
  const AddAddressScreen({
    super.key,
    this.existingAddress,
  });

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
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      // Edit mode: Agar comma-separated format hai to main address extract karein
      addressController.text = widget.existingAddress!.address.split(',').first;
      zipController.text = widget.existingAddress!.zipcode.toString();
      cityController.text = widget.existingAddress!.city ?? "";
      saveAddress = widget.existingAddress!.isSave ?? false;
      country = widget.existingAddress!.country.isNotEmpty ? widget.existingAddress!.country : "Pakistan";

      String phone = widget.existingAddress!.phone;
      if (phone.startsWith("+92")) {
        phone = phone.replaceFirst("+92", "");
      }
      phoneController.text = phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state.selectedAddress != null) {
          Navigator.pop(context);
        }
      },
      child:Scaffold(
        appBar: CustomAppBar(
          title: StringResources.checkout,
          showBackButton: true,
        ),
        body: Column(
          children: [
            Card(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              elevation: 0,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 10.h),
                    child: Row(
                      children: [
                        SizedBox(width: 50.w),
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 3.w),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 2.h, color: Colors.grey.shade400),
                        ),
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade400),
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
                        Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.w600)),
                        Text("Payment Method", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
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
                      const Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 6.h),
                      AuthTextField(
                        label: "",
                        controller: addressController,
                        validator: (v) => v == null || v.isEmpty ? "Required" : null,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Zip Code", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 6.h),
                                AuthTextField(
                                  label: "",
                                  keyboardType: TextInputType.number,
                                  controller: zipController,
                                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("City", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 6.h),
                                AuthTextField(
                                  label: "",
                                  controller: cityController,
                                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      const Text("Phone", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 6.h),
                      AuthTextField(
                        label: "",
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        validator: (v) => v?.validateMobile(),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("🇵🇰"),
                              const SizedBox(width: 6),
                              Text(
                                "+92",
                                style: TextStyle(
                                  fontSize: DimensionsResources.FONT_SIZE_MEDIUM.w,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const Text("Country", style: TextStyle(fontWeight: FontWeight.bold)),
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
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                            onTap: () => setState(() => saveAddress = !saveAddress),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: saveAddress ? Colors.green : Colors.grey, width: 2.w),
                                color: saveAddress ? Colors.green : Colors.transparent,
                              ),
                              child: saveAddress ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
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
            SizedBox(height: DimensionsResources.D_30.h)
          ],
        ),
      )
    );
  }


  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    String phone = phoneController.text.trim();

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    final formattedPhone = "+92$phone";

    final newAddress = AddressModel(
      id: widget.existingAddress?.id ?? "",
      locationname: widget.existingAddress?.locationname ?? "Saved Address",
      username: widget.existingAddress?.username ?? "User",
      phone: formattedPhone,
      address: addressController.text.trim(),
      zipcode: int.tryParse(zipController.text.trim()) ?? 0,
      city: cityController.text.trim(),
      country: country,
      isSave: saveAddress,
    );

    final bloc = context.read<AddressBloc>();

    if (widget.existingAddress != null) {
      bloc.add(UpdateAddressEvent(newAddress));
    } else {
      bloc.add(AddAddressEvent(newAddress, saveAddress));
    }
  }
}