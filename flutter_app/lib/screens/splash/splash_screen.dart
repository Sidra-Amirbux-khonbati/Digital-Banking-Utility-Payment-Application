import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.userType,
        );

      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.primary,


      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [


            const Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 90,
            ),


            const SizedBox(height: 20),


            const Text(
              "Bill Express",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 10),


            const Text(
              "Digital Banking System",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),


            const SizedBox(height: 30),


            const CircularProgressIndicator(
              color: Colors.white,
            ),

          ],
        ),
      ),
    );
  }
}