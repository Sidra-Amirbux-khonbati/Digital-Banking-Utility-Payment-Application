import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import 'customer_bill_details_screen.dart';

class CustomerBillsScreen extends StatefulWidget {
  const CustomerBillsScreen({super.key});

  @override
  State<CustomerBillsScreen> createState() => _CustomerBillsScreenState();
}

class _CustomerBillsScreenState extends State<CustomerBillsScreen> {
  List bills = [];
  bool isLoading = true;

  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  Future<void> loadBills() async {
    setState(() {
      isLoading = true;
    });

    final customer = SessionService.customer!;

    final data = await ApiService.getCustomerBills(
      customer["account_no"].toString(),
      selectedStatus,
    );

    setState(() {
      bills = data;
      isLoading = false;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;

      case "Pending":
        return Colors.orange;

      case "Overdue":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData getCompanyIcon(String company) {
    company = company.toLowerCase();

    if (company.contains("electric")) {
      return Icons.flash_on;
    }

    if (company.contains("gas")) {
      return Icons.local_fire_department;
    }

    if (company.contains("water")) {
      return Icons.water_drop;
    }

    if (company.contains("internet")) {
      return Icons.wifi;
    }

    return Icons.receipt_long;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bills"), centerTitle: true),

      body: Column(
        children: [
          const SizedBox(height: 10),

          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),

              children: [
                filterChip("All"),

                filterChip("Pending"),

                filterChip("Overdue"),

                filterChip("Paid"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : bills.isEmpty
                ? const Center(
                    child: Text(
                      "No Bills Found",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadBills,

                    child: ListView.builder(
                      itemCount: bills.length,

                      itemBuilder: (context, index) {
                        final bill = bills[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),

                          elevation: 4,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(15),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,

                                      child: Icon(
                                        getCompanyIcon(bill["company_name"]),
                                        color: Colors.blue,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            bill["company_name"],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),

                                          Text(bill["billing_month"]),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),

                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          bill["bill_status"],
                                        ),

                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Text(
                                        bill["bill_status"],

                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(height: 25),

                                Text("Bill No : ${bill["bill_id"]}"),

                                const SizedBox(height: 5),

                                Text("Consumer No : ${bill["consumer_no"]}"),

                                const SizedBox(height: 5),

                                Text("Due Date : ${bill["due_date"]}"),

                                const SizedBox(height: 12),

                                Text(
                                  "Rs. ${bill["amount"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.green,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,

                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CustomerBillDetailsScreen(
                                                bill: bill,
                                              ),
                                        ),
                                      );
                                    },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          bill["bill_status"] == "Paid"
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),

                                    child: Text(
                                      bill["bill_status"] == "Paid"
                                          ? "View Receipt"
                                          : "Pay Now",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String status) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ChoiceChip(
        label: Text(status),

        selected: selectedStatus == status,

        onSelected: (_) {
          setState(() {
            selectedStatus = status;
          });

          loadBills();
        },
      ),
    );
  }
}
