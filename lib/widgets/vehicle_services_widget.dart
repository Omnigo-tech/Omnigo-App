import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/strings-resource.dart';

class VehicleServicesWidget extends StatelessWidget {
  final List<Map<String, String>> services;

  const VehicleServicesWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      children: [
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 153.h,
          child: _buildServiceCard(services[0]),
        ),
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 85.h,
          child: _buildServiceCard(services[1]),
        ),
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 85.h,
          child: _buildServiceCard(services[2]),
        ),
        // Index 3: Horizontal card (Rider) - 183 x 85
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 85.h,
          child: _buildServiceCard(services[3]),
        ),
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 85.h,
          child: _buildServiceCard(services[4]),
        ),
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 85.h,
          child: _buildServiceCard(services[5]),
        ),
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 153.h,
          child: _buildServiceCard(services[6]),
        ),
        StaggeredGridTile.extent(
          crossAxisCellCount: 1,
          mainAxisExtent: 85.h,
          child: _buildServiceCard(services[7]),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, String> item) {
    final bool isSoon = item['title'] == "SOON";

    return Container(
      padding: EdgeInsets.all(DimensionsResources.D_12.sp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFDBF6FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(DimensionsResources.D_16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isSoon
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, color: Colors.black54),
                SizedBox(height: 4.h),
                Text(
                  StringResources.soon,
                  style: GoogleFonts.dmSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Text(
                  item['title']!,
                  style: GoogleFonts.dmSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    item['image']!,
                    height: 45.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
    );
  }
}
