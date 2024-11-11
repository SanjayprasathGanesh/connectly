import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/auth_provider.dart';
import 'package:connectly/view/pages/home_page.dart';
import 'package:connectly/view/pages/my_chats.dart';
import 'package:connectly/view/pages/my_likes.dart';
import 'package:connectly/view/pages/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toast/toast.dart';

import '../../services/common_methods.dart';
import '../widgets/custom_floating_button.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final List<Widget> pages = [
    const MyHomePage(),
    const MyChats(),
    const MyLikes(),
    const MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connectly",style: TextStyle(
            color: Colors.black,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFfb6f92),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onTap: () {
                      logout(context);
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: pages[pageIndex],
      backgroundColor: const Color(0xFFffc2d1),
      bottomNavigationBar: ResponsiveBreakpoints.of(context).isMobile
          ? showBottomNavBar()
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFloatingActionButton(),
    );
  }

  Widget showBottomNavBar() {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: pageIndex,
      onTap: (int index) {
        setState(() {
          pageIndex = index;
        });
      },
      backgroundColor: const Color(0xFFfb6f92),
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      activeColor: Colors.white,
      inactiveColor: Colors.black,
    );
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Do You want to Logout from this Account',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                ToastContext().init(context);
                context.router.popUntilRoot();
                AuthProvider authProvider = Get.find<AuthProvider>();
                authProvider.logout();
                Toast.show(
                  'Logged out Successfully',
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: 15.0,
                  ),
                  backgroundColor: Colors.yellow,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'OpenSans', color: Colors.black),
              ),
            ),
            const SizedBox(width: 15.0),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'OpenSans', color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
