import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';

import '../../data/models/fast_foods_models/fast_food_category_model.dart';
import 'category_item.dart';

class CategorySelector extends StatefulWidget {

  final List<SubCategoryModel> items;

  final int selectedIndex;

  final ValueChanged<int> onChanged;

  const CategorySelector({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<CategorySelector> createState() =>
      _CategorySelectorState();
}

class _CategorySelectorState
    extends State<CategorySelector> {

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(
      covariant CategorySelector oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedIndex !=
        widget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  void _scrollToIndex(int index) {

    if (!_scrollController.hasClients) {
      return;
    }

    if (index < 0 || index >= widget.items.length) {
      return;
    }

    final double itemWidth = 88.w;

    final double screenWidth =
        MediaQuery.of(context).size.width;

    double targetOffset =
        (index * itemWidth) -
            (screenWidth / 2) +
            (itemWidth / 2) +
            16.w;

    if (targetOffset <
        _scrollController.position.minScrollExtent) {
      targetOffset =
          _scrollController.position.minScrollExtent;
    }

    if (targetOffset >
        _scrollController.position.maxScrollExtent) {
      targetOffset =
          _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      targetOffset,
      duration:
      const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 90.12.h,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius:
        BorderRadius.circular(17.r),
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(17.r),

        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding:
          EdgeInsets.symmetric(horizontal: 16.w),

          itemCount: widget.items.length,

          itemBuilder: (context, index) {

            return CategoryItem(
              item: widget.items[index],

              isSelected:
              index == widget.selectedIndex,

              onTap: () {
                widget.onChanged(index);

                _scrollToIndex(index);
              },
            );
          },
        ),
      ),
    );
  }
}