import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';

class FastFoodFilterSheet extends StatefulWidget {
  const FastFoodFilterSheet({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FastFoodFilterSheet(),
    );
  }

  @override
  State<FastFoodFilterSheet> createState() => _FastFoodFilterSheetState();
}

class _FastFoodFilterSheetState extends State<FastFoodFilterSheet> {
  // Checkbox States
  bool fastDelivery = false;
  bool freeDelivery = false;

  bool off20Percent = false;
  bool freeItems = false;
  bool buy1Get1 = false;

  String? selectedPrice; // 'high_to_low' or 'low_to_high'
  String? selectedRating; // 'top_rated', '4.5+', '4.0+'
  String? selectedDistance = 'any_distance'; // Default selected option

  void _resetFilters() {
    setState(() {
      fastDelivery = false;
      freeDelivery = false;
      off20Percent = false;
      freeItems = false;
      buy1Get1 = false;
      selectedPrice = null;
      selectedRating = null;
      selectedDistance = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // HEADER: Close, Title, Reset
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: 22.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // FILTER CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. DELIVERY
                  _buildSectionTitle('Delivery'),
                  _buildCheckboxRow('Fast Delivery', fastDelivery, (val) {
                    setState(() => fastDelivery = val!);
                  }),
                  _buildCheckboxRow('Free Delivery', freeDelivery, (val) {
                    setState(() => freeDelivery = val!);
                  }),
                  _buildDivider(),

                  // 2. OFFERS
                  _buildSectionTitle('Offers'),
                  _buildCheckboxRow('20% Off', off20Percent, (val) {
                    setState(() => off20Percent = val!);
                  }),
                  _buildCheckboxRow('Free items', freeItems, (val) {
                    setState(() => freeItems = val!);
                  }),
                  _buildCheckboxRow('Buy 1, Get 1 free', buy1Get1, (val) {
                    setState(() => buy1Get1 = val!);
                  }),
                  _buildDivider(),

                  // 3. PRICE
                  _buildSectionTitle('Price'),
                  _buildRadioRow('High to low', 'high_to_low', selectedPrice, (val) {
                    setState(() => selectedPrice = val);
                  }),
                  _buildRadioRow('Low to high', 'low_to_high', selectedPrice, (val) {
                    setState(() => selectedPrice = val);
                  }),
                  _buildDivider(),

                  // 4. RATING
                  _buildSectionTitle('Rating'),
                  _buildRadioRow('Top rated', 'top_rated', selectedRating, (val) {
                    setState(() => selectedRating = val);
                  }),
                  _buildRadioRow('4.5 +', '4.5_plus', selectedRating, (val) {
                    setState(() => selectedRating = val);
                  }),
                  _buildRadioRow('4.0 +', '4.0_plus', selectedRating, (val) {
                    setState(() => selectedRating = val);
                  }),
                  _buildDivider(),

                  // 5. DISTANCE
                  _buildSectionTitle('Distance'),
                  _buildRadioRow('Near me', 'near_me', selectedDistance, (val) {
                    setState(() => selectedDistance = val);
                  }),
                  _buildRadioRow('Within 3 km', '3_km', selectedDistance, (val) {
                    setState(() => selectedDistance = val);
                  }),
                  _buildRadioRow('Within 5 km', '5_km', selectedDistance, (val) {
                    setState(() => selectedDistance = val);
                  }),
                  _buildRadioRow('Any Distance', 'any_distance', selectedDistance, (val) {
                    setState(() => selectedDistance = val);
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // APPLY BUTTON
          Container(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // App primary color (Blue)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Apply filter logic
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply filter',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Helper
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Checkbox Item Helper
  Widget _buildCheckboxRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 24.r,
              width: 24.r,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                side: BorderSide(color: Colors.grey.shade400, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Radio Selection Helper (Square Radio Look like UI image)
  Widget _buildRadioRow(String label, String value, String? groupValue, ValueChanged<String?> onChanged) {
    final bool isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
            Container(
              width: 18.r,
              height: 18.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 1.2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                Icons.check,
                size: 12.r,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Divider Helper
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: Colors.grey.shade200,
      ),
    );
  }
}