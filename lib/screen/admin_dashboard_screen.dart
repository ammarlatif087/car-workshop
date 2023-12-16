import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:workshop/screen/complaints_screen.dart';
import 'package:workshop/screen/profile_screen.dart';
import 'package:workshop/screen/subscriptions_screen.dart';
import 'package:workshop/screen/users_screen.dart';

import '../model/nav_model.dart';
import '../model/user.dart';
import '../utils/MyImages.dart';
import '../utils/color_resources.dart';
import '../utils/utils.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({
    super.key,
  });

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final List<Widget> _screens = [];
  List<Widget> bottomNavBars = [];
  List<BottomNavModel> bottomNavBarsData = [];

  List<User> users = [];
  List<User> workShops = [];

  @override
  void initState() {
    super.initState();
    _screens.add(UsersScreen(
      title: "Users",
      role: "User",
    ));
    _screens.add(UsersScreen(
      title: "Work Shops",
      isRemoveOptionShow: true,
      role: "Workshop",
      detailsTitle: "Workshop Details",
    ));
    _screens.add(ComplaintsScreen());
    _screens.add(SubscriptionsScreen());
    _screens.add(const ProfileScreen());
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
            getBottomNavItem(manImage),
            getBottomNavItem(workshopImage),
            // getBottomNavItem(graphIcon),
            getBottomNavItem(complaintIcon),
            getBottomNavItem(subscriptionsImage),
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
