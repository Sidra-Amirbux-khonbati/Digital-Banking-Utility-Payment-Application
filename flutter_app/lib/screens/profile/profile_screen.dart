import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget profileTile(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customer = SessionService.customer!;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          "Customer Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, color: Colors.white, size: 45),
            ),

            const SizedBox(height: 20),

            Text(
              "${customer["first_name"]} ${customer["last_name"]}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            profileTile(
              Icons.person,
              "Name",
              "${customer["first_name"]} ${customer["last_name"]}",
            ),

            profileTile(
              Icons.badge,
              "Card Number",
              customer["card_no"]?.toString() ?? "",
            ),

            profileTile(Icons.email, "Email", customer["email"] ?? ""),

            profileTile(Icons.phone, "Mobile", customer["mobile"] ?? ""),

            profileTile(
              Icons.business,
              "Office",
              customer["office_name"] ?? "",
            ),

            profileTile(
              Icons.flag,
              "Nationality",
              customer["nationality"] ?? "",
            ),

            profileTile(
              Icons.location_on,
              "Address",
              customer["address"] ?? "",
            ),

            profileTile(
              Icons.account_balance_wallet,
              "Account Number",
              customer["account_no"].toString(),
            ),

            profileTile(
              Icons.credit_card,
              "Account Type",
              customer["account_type"] ?? "",
            ),

            profileTile(
              Icons.verified,
              "Status",
              customer["account_status"] ?? "",
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {
                  SessionService.logout();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
