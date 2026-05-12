import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/data/models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;

  const MessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DimensionsResources.D_16.w,
        vertical: DimensionsResources.D_4.h,
      ),
      alignment: message.isUser ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * DimensionsResources.D_0_7,
        ),
        padding: EdgeInsets.all(DimensionsResources.D_12.r),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.darkGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(DimensionsResources.RADIUS_LARGE.r),
            topRight: Radius.circular(DimensionsResources.RADIUS_LARGE.r),
            bottomLeft: Radius.circular(
              message.isUser ? DimensionsResources.RADIUS_LARGE.r : DimensionsResources.D_0,
            ),
            bottomRight: Radius.circular(
              message.isUser ? DimensionsResources.D_0 : DimensionsResources.RADIUS_LARGE.r,
            ),
          ),
        ),
        child: Text(
          message.text,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}