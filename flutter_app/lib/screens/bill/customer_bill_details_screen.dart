import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/api_service.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../services/api_urls.dart';

class CustomerBillDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bill;

  const CustomerBillDetailsScreen({super.key, required this.bill});

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Overdue":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> openReceipt(String billId) async {
    final Uri url = Uri.parse("${ApiUrls.baseUrl}/bill/receipt/$billId");

    final result = await launchUrl(url, mode: LaunchMode.externalApplication);

    print("Launch Result: $result");
  }

  @override
  Widget build(BuildContext context) {
    final customer = SessionService.customer!;

    final amount = double.parse(bill["amount"].toString());
    final fine = double.parse(bill["fine"].toString());
    final total = amount + fine;

    print(fine);

    return Scaffold(
      appBar: AppBar(title: const Text("Bill Details"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          elevation: 5,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 35,
                    child: Icon(Icons.receipt_long, size: 35),
                  ),
                ),

                const SizedBox(height: 25),

                buildTile("Bill ID", bill["bill_id"].toString()),

                buildTile("Company", bill["company_id"].toString()),

                buildTile("Consumer No", bill["consumer_no"].toString()),

                buildTile("Billing Month", bill["billing_month"].toString()),

                buildTile("Issue Date", bill["bill_issue_date"].toString()),

                buildTile("Due Date", bill["due_date"].toString()),

                buildTile(
                  "Customer Account",
                  customer["account_no"].toString(),
                ),

                const Divider(height: 35),

                const Text(
                  "Bill Amount",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PKR ${amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),

                    if (fine > 0) ...[
                      const SizedBox(height: 10),

                      Text(
                        "+ Late Fee: PKR ${fine.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(height: 25),

                      Text(
                        "Total Payable: PKR ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        color: getStatusColor(
                          bill["bill_status"],
                        ).withOpacity(.15),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        bill["bill_status"],
                        style: TextStyle(
                          color: getStatusColor(bill["bill_status"]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                buildTile("Remarks", bill["remarks"].toString()),

                const SizedBox(height: 35),

                if (bill["bill_status"] != "Paid")
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text("Cancel"),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Payment"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Bill ID : ${bill["bill_id"]}"),
                                      const SizedBox(height: 8),
                                      Text("Company : ${bill["company_id"]}"),
                                      const SizedBox(height: 8),
                                      Text("Amount : PKR ${total}"),
                                      const SizedBox(height: 15),
                                      const Text(
                                        "Are you sure you want to pay this bill?",
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Confirm"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm != true) return;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              final response = await ApiService.customerPayBill(
                                bill["bill_id"],
                              );

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response["message"]),
                                  backgroundColor: Colors.green,
                                ),
                              );

                            } catch (e) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },

                          child: const Text("Pay Now"),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await openReceipt(bill["bill_id"]);
                      },
                      icon: const Icon(Icons.receipt),

                      label: const Text("View Receipt"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
