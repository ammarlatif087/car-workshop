import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:workshop/screen/add_complaint_screen.dart';
import 'package:workshop/screen/complaints_screen.dart';
import 'package:workshop/screen/packages_screen.dart';
import 'package:workshop/screen/profile_screen.dart';
import 'package:workshop/screen/user_home_screen.dart';
import 'package:workshop/screen/users_screen.dart';
import 'package:workshop/screen/vehicle_models_screen.dart';
import 'package:workshop/screen/workshop_bookings_screen.dart';
import 'package:workshop/screen/workshop_home_screen.dart';
import 'package:workshop/screen/workshop_orders_screen.dart';

import '../model/nav_model.dart';
import '../model/user.dart';
import '../utils/MyImages.dart';
import '../utils/color_resources.dart';
import '../utils/utils.dart';

class WorkShopDashboardWidget extends StatefulWidget {
  const WorkShopDashboardWidget({
    super.key,
  });

  @override
  State<WorkShopDashboardWidget> createState() =>
      _WorkShopDashboardWidgetState();
}

class _WorkShopDashboardWidgetState extends State<WorkShopDashboardWidget> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final List<Widget> _screens = [];
  List<Widget> bottomNavBars = [];
  List<BottomNavModel> bottomNavBarsData = [];

  @override
  void initState() {
    super.initState();
    _screens.add(const WorkShopHomeScreen());
    _screens.add(const VehicleModelsScreen());
    _screens.add(WorkshopOrdersScreen());
    _screens.add(const WorkshopBookingsScreen());
    _screens.add( const ProfileScreen());

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //
    //   startNewScreenWithRoot(context, PackagesScreen(), true);
    //
    // });|

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _pageIndex = 0;
          _pageController.jumpToPage(0);
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: DotNavigationBar(
          enableFloatingNavBar: false,
          backgroundColor: Theme.of(context).cardColor,
          // curve:  Curves.,
          currentIndex: _pageIndex,
          onTap: (p0) {
            setState(() {
              _pageIndex = p0;
              _pageController.jumpToPage(p0);
            });
          },
          dotIndicatorColor: isDarkMode(context) ? Colors.white : Colors.black,
          // enableFloatingNavBar: false
          items: [
            getBottomNavItem(homeIcon),
            getBottomNavItem(carIcon),
            getBottomNavItem(ordersIcon),

            getBottomNavItem(bookingIcon),
            getBottomNavItem(profileIcon),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }
}
