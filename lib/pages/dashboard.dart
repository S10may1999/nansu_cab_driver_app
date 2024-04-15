import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nansu_driver/authentication/login_screen.dart';
import 'package:nansu_driver/pages/earning_page.dart';
import 'package:nansu_driver/pages/home_page.dart';
import 'package:nansu_driver/pages/profile_page.dart';
import 'package:nansu_driver/pages/trips_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int indexSelected = 0;

  onBarItemSelected(int i) {
    setState(() {
      indexSelected = i;
      tabController!.index = indexSelected;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          currentIndex: indexSelected,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: onBarItemSelected,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: "Earnings"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_tree), label: "Trips"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomePage(),
          EarningPage(),
          TripsPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
