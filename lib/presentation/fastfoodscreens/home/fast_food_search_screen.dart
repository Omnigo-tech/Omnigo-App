import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import '../../../widgets/custom_search_bar_widget.dart';

class FastFoodSearchScreen extends StatefulWidget {
  const FastFoodSearchScreen({Key? key}) : super(key: key);

  @override
  State<FastFoodSearchScreen> createState() => _FastFoodSearchScreenState();
}

class _FastFoodSearchScreenState extends State<FastFoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Recent searches list
  List<String> recentSearches = [
    'Pizza Garden',
    'Qaisar Kitchen',
    'Matko Matki',
  ];

  // Popular cuisine items
  final List<Map<String, String>> popularCuisines = [
    {'title': 'Burger', 'image': ImageResource.BURGER_IMG},
    {'title': 'Pizza', 'image': ImageResource.PIZA_IMG},
    {'title': 'Crispy', 'image': ImageResource.CRISPY_IMG},
    {'title': 'Pasta', 'image': ImageResource.PASTA_IMG},
    {'title': 'Roll', 'image': ImageResource.ROLL_IMG},
  ];

  // Sponsored vendors
  final List<Map<String, String>> sponsoredVendors = [
    {'title': 'Qaisar Kitchen', 'logo': ImageResource.QAISER_LOGO},
    {'title': 'Pizza Garden', 'logo': ImageResource.PIZA_GARDEN_LOGO},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP SEARCH BAR WITH BACK BUTTON USING CustomSearchBar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      hintText: 'Search foods or dishes...',
                      backgroundColor: const Color(0xFFF2F2F2),
                      onChanged: (value) {
                        // Real-time search filter logic handle kar sakte hain
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 2. POPULAR CUISINE SECTION
              Text(
                'Popular cuisine',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 95.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularCuisines.length,
                  itemBuilder: (context, index) {
                    final item = popularCuisines[index];
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = item['title'] ?? '';
                        _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _searchController.text.length),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.w),
                        child: Column(
                          children: [
                            Container(
                              width: 62.r,
                              height: 62.r,
                              padding: EdgeInsets.all(8.r),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEBF3FF),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  item['image'] ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.fastfood,
                                          size: 28.r, color: AppColors.primary),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              item['title'] ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),

              // 3. RECENT SEARCH SECTION
              if (recentSearches.isNotEmpty) ...[
                Text(
                  'Recent Search',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    final searchTerm = recentSearches[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 20.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _searchController.text = searchTerm;
                                _searchController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _searchController.text.length),
                                );
                              },
                              child: Text(
                                searchTerm,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                recentSearches.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 18.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 32.h),
              ],

              // 4. SPONSORED BY OMINIGO SECTION
              Text(
                'Sponsored by Ominigo',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 14.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 10.h,
                children: sponsoredVendors.map((vendor) {
                  return Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF0F0F0),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              vendor['logo'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.store,
                                      size: 16.r, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          vendor['title'] ?? '',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Sponsored',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0066FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}