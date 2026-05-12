import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';

import '../core/helper/constants/strings-resource.dart';

class ChatInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DimensionsResources.D_16.w,
        vertical: DimensionsResources.D_8.h,
      ),
      color: AppColors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.itemBackground,
          borderRadius: BorderRadius.circular(DimensionsResources.RADIUS_EXTRA_LARGE.r),
        ),
        child: Row(
          children: [
            SizedBox(width: DimensionsResources.D_16.w),
            Expanded(
              child: TextField(
                controller: controller,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: StringResources.writeMessage,
                  hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: DimensionsResources.D_10.h),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onSendMessage(value);
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: AppColors.lightText,
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onSendMessage(controller.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}