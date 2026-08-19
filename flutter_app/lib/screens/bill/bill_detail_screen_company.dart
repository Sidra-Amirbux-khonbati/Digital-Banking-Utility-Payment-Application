import 'package:flutter/material.dart';

class BillDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bill Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.receipt_long,
                    size: 70,
                    color: Colors.indigo,
                  ),
                ),

                const SizedBox(height: 20),

                detailTile("Bill ID", bill["bill_id"].toString()),

                detailTile("Company", bill["company_id"].toString()),

                detailTile(
                  "Customer Account",
                  bill["customer_account_no"].toString(),
                ),

                detailTile("Consumer No", bill["consumer_no"].toString()),

                detailTile("Billing Month", bill["billing_month"].toString()),

                detailTile("Issue Date", bill["bill_issue_date"].toString()),

                detailTile("Due Date", bill["due_date"].toString()),

                detailTile("Amount", "PKR ${bill["amount"]}"),

                detailTile("Status", bill["bill_status"].toString()),

                detailTile("Remarks", bill["remarks"].toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget detailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
