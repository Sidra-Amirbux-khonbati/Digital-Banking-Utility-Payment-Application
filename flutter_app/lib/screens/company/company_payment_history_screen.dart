import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CompanyPaymentHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyPaymentHistoryScreen({super.key, required this.company});

  @override
  State<CompanyPaymentHistoryScreen> createState() =>
      _CompanyPaymentHistoryScreenState();
}

class _CompanyPaymentHistoryScreenState
    extends State<CompanyPaymentHistoryScreen> {
  // Dummy Data
  List<dynamic> payments = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          "Payment History",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search Customer Account",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: summaryCard(
                          "Payments",
                          payments.length.toString(),
                          Colors.green,
                          Icons.payments,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: summaryCard(
                          "Revenue",
                          "PKR ${payments.fold(0.0, (sum, item) => sum + double.parse(item["amount"].toString())).toStringAsFixed(0)}",
                          Colors.indigo,
                          Icons.account_balance_wallet,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final payment = payments[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.payments, color: Colors.white),
                            ),

                            title: Text(
                              payment["transaction_id"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Customer : ${payment["from_account"]}"),

                                Text("Amount : PKR ${payment["amount"]}"),

                                Text(
                                  payment["created_at"].toString().substring(
                                    0,
                                    10,
                                  ),
                                ),
                              ],
                            ),

                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Received",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> loadPayments() async {
    try {
      final data = await ApiService.getCompanyPayments(
        widget.company["company_account_no"].toString(),
      );

      setState(() {
        payments = data;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Widget summaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [
            Icon(icon, color: color, size: 35),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(title),
          ],
        ),
      ),
    );
  }
}
