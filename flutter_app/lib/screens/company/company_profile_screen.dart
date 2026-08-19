import 'package:flutter/material.dart';
import '../auth/company_login_screen.dart';

class CompanyProfileScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const CompanyProfileScreen({super.key, required this.company});

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
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text(
          "Company Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.business, size: 45, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              company["company_name"] ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            profileTile(Icons.badge, "Company ID", company["company_id"] ?? ""),

            profileTile(
              Icons.category,
              "Company Type",
              company["company_type"] ?? "",
            ),

            profileTile(
              Icons.account_balance,
              "Company Account",
              company["company_account_no"].toString(),
            ),

            profileTile(Icons.email, "Email", company["contact_email"] ?? ""),
            profileTile(Icons.phone, "Phone", company["contact_phone"] ?? ""),
            profileTile(
              Icons.verified,
              "Status",
              company["company_status"] ?? "",
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
                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (_) => const CompanyLoginScreen(),
                    ),

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
