import 'package:flutter/material.dart';
import 'generate_bill_screen.dart';
import 'company_bills_screen.dart';
import 'company_profile_screen.dart';
import 'company_payment_history_screen.dart';

class CompanyDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const CompanyDashboardScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        backgroundColor: Colors.indigo,

        title: const Text(
          "Company Dashboard",
          style: TextStyle(color: Colors.white),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Card(
              elevation: 5,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.indigo,
                      child: Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      company["company_name"],

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("Company ID : ${company["company_id"]}"),

                    Text("Account No : ${company["company_account_no"]}"),

                    Text("Status : ${company["company_status"]}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            GridView.count(
              crossAxisCount: 2,

              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisSpacing: 15,

              mainAxisSpacing: 15,

              children: [
                dashboardCard(
                  Icons.receipt_long,
                  context,
                  "Generate Bill",
                  Colors.orange,
                ),

                dashboardCard(
                  Icons.history,
                  context,
                  "Payment History",
                  Colors.blue,
                ),

                dashboardCard(
                  Icons.payment,
                  context,
                  "View Bills",
                  Colors.green,
                ),

                dashboardCard(Icons.person, context, "Profile", Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    IconData icon,
    BuildContext context,

    String title,
    Color color,
  ) {
    return Card(
      elevation: 4,

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (title == "Profile") {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => CompanyProfileScreen(company: company),
              ),
            );
          } else if (title == "Payment History") {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => CompanyPaymentHistoryScreen(company: company),
              ),
            );
          } else if (title == "Generate Bill") {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) => GenerateBillScreen(company: company),
              ),
            );
          } else if (title == "View Bills") {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) => CompanyBillsScreen(company: company),
              ),
            );
          }
        },

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 45, color: color),

            const SizedBox(height: 15),

            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
