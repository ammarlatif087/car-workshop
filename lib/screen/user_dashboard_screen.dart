import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:workshop/provider/user_cart_provider.dart';
import 'package:workshop/screen/complaints_screen.dart';
import 'package:workshop/screen/profile_screen.dart';
import 'package:workshop/screen/user_bokkings_screen.dart';
import 'package:workshop/screen/user_carts_screen.dart';
import 'package:workshop/screen/user_home_screen.dart';
import 'package:workshop/screen/user_orders_screen.dart';

import '../model/nav_model.dart';
import '../utils/MyImages.dart';
import '../utils/utils.dart';

class UserDashboardWidget extends StatefulWidget {
  const UserDashboardWidget({
    super.key,
  });

  @override
  State<UserDashboardWidget> createState() => _UserDashboardWidgetState();
}

class _UserDashboardWidgetState extends State<UserDashboardWidget> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final List<Widget> _screens = [];
  List<Widget> bottomNavBars = [];
  List<BottomNavModel> bottomNavBarsData = [];

  @override
  void initState() {
    super.initState();

    _screens.add(UserHomeScreen());
    _screens.add(UserCartsScreen());
    _screens.add(const UserBookingsScreen());
    _screens.add(UserOrdersScreen());
    _screens.add(ComplaintsScreen(
      isForUser: true,
    ));
    _screens.add(const ProfileScreen());

    // _screens.add(const RoutinesScreen());
    // _screens.add(StatsScreen());
    // _screens.add(SettingsScreen());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProvider<UserCartProvider>(context).getData();
    });
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
            getBottomNavItem(cartIcon),
            getBottomNavItem(bookingIcon),
            getBottomNavItem(ordersIcon),
            getBottomNavItem(complaintIcon),
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
