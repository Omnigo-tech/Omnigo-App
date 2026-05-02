import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';
import '../core/helper/constants/strings-resource.dart';
import '../presentation/screens/user_interface/favourite/favourite_screen.dart';
import '../presentation/screens/user_interface/home/home_screen.dart';

class AppBottomBar extends StatefulWidget {
  final Widget? body;
  final int initialIndex;

  const AppBottomBar({
    super.key,
    this.body,
    this.initialIndex = 0,
  });

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const HomeScreen(),
    const FavouriteScreen(),
    const HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If a custom body is provided (like GroceryHomeScreen), use it.
    // Otherwise, use the screen based on the selected index.
    Widget currentBody = widget.body != null && _selectedIndex == widget.initialIndex
        ? widget.body!
        : _screens[_selectedIndex];

    return Scaffold(
      body: currentBody,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.black,
        selectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 12.sp,
              color: AppColors.primary,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 12.sp,
              color: AppColors.black,
            ),
        items: [
          _buildNavItem(ImageResource.ICON_HOME, StringResources.home, 0),
          _buildNavItem(ImageResource.ICON_ORDER, StringResources.myOrder, 1),
          _buildNavItem(
            ImageResource.ICON_FAVOURITE,
            StringResources.favourite,
            2,
          ),
          _buildNavItem(ImageResource.ICON_USER, StringResources.account, 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    String iconPath,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: DimensionsResources.D_20.w,
        height: DimensionsResources.D_20.h,
        colorFilter: ColorFilter.mode(
          _selectedIndex == index ? AppColors.primary : AppColors.black,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
