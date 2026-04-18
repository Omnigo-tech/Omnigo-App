
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';

import '../core/helper/constants/strings-resource.dart';

class VehicleServicesWidget extends StatefulWidget {
  final List<Map<String, String>> services;
  VehicleServicesWidget({super.key,
    required this.services
  });

  @override
  State<VehicleServicesWidget> createState() => _VehicleServicesWidgetState();
}

class _VehicleServicesWidgetState extends State<VehicleServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2, //
      ),
      itemBuilder: (context, index) {
        final item = widget.services[index];
        final isSoon = item['title'] == "SOON";

        return Container(
          padding: EdgeInsets.all(DimensionsResources.D_16.sp),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFDBF6FF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(DimensionsResources.D_18.r),
          ),
          child: isSoon
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: DimensionsResources.D_21.sp),
                SizedBox(height: DimensionsResources.D_4.h),
                Text(
                  StringResources.soon,
                  style: TextStyle(
                    fontSize:  DimensionsResources.D_12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title']!,
                style: GoogleFonts.lora(
                  fontSize: DimensionsResources.D_14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  item['image']!,
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
