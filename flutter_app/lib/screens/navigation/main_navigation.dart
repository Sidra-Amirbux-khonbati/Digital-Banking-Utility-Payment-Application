import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../transaction/transaction_screen.dart';
import '../transaction/deposit_money_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final Map<String, dynamic> customer;

  const MainNavigation({super.key, required this.customer});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(customer: widget.customer),
      TransactionScreen(customer: widget.customer),
      DepositMoneyScreen(customer: widget.customer),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: "Transaction",
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: "Deposit",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
