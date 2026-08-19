import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../bill/bill_detail_screen_company.dart';
import 'package:fl_chart/fl_chart.dart';

class CompanyBillsScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyBillsScreen({super.key, required this.company});

  @override
  State<CompanyBillsScreen> createState() => _CompanyBillsScreenState();
}

class _CompanyBillsScreenState extends State<CompanyBillsScreen> {
  Map<String, dynamic>? summary;
  Map<String, dynamic>? statistics;

  bool loading = true;
  List<dynamic> bills = [];

  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();

    loadSummary();
    loadBills();
    loadStatistics();
  }

  Future<void> loadSummary() async {
    try {
      final data = await ApiService.getCompanyBillSummary(
        widget.company["company_id"],
      );

      setState(() {
        summary = data;

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> loadStatistics() async {
    

    try {
      final data = await ApiService.getBillStatistics(
        widget.company["company_id"],
      );
      print(data);

      setState(() {
        statistics = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadBills() async {
    try {
      final data = await ApiService.getCompanyBills(
        widget.company["company_id"],
        selectedStatus,
      );

      setState(() {
        bills = data;
      });
    } catch (e) {
      print(e);
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(title),
          ],
        ),
      ),
    );
  }

  Widget billPieChart() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Bill Status Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value:
                          double.tryParse(
                            (statistics?["paid_percentage"] ?? "0").toString(),
                          ) ??
                          0,
                      title: "${statistics?["paid_percentage"] ?? "0"}%",
                      color: Colors.green,
                    ),

                    PieChartSectionData(
                      value:
                          double.tryParse(
                            (statistics?["pending_percentage"] ?? "0")
                                .toString(),
                          ) ??
                          0,
                      title: "${statistics?["pending_percentage"] ?? "0"}%",
                      color: Colors.orange,
                    ),

                    PieChartSectionData(
                      value:
                          double.tryParse(
                            (statistics?["overdue_percentage"] ?? "0")
                                .toString(),
                          ) ??
                          0,
                      title: "${statistics?["overdue_percentage"] ?? "0"}%",
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(width: 12, height: 12, color: Colors.green),
                    const SizedBox(width: 5),
                    const Text("Paid"),
                  ],
                ),

                Row(
                  children: [
                    Container(width: 12, height: 12, color: Colors.orange),
                    const SizedBox(width: 5),
                    const Text("Pending"),
                  ],
                ),

                Row(
                  children: [
                    Container(width: 12, height: 12, color: Colors.red),
                    const SizedBox(width: 5),
                    const Text("Overdue"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text("My Bills", style: TextStyle(color: Colors.white)),

        backgroundColor: Colors.indigo,

        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    widget.company["company_name"],

                    style: const TextStyle(
                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GridView.count(
                    crossAxisCount: 2,

                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    crossAxisSpacing: 15,

                    mainAxisSpacing: 15,

                    children: [
                      summaryCard(
                        "Total",
                        summary?["total"] ?? "0",
                        Colors.indigo,
                        Icons.receipt_long,
                      ),

                      summaryCard(
                        "Paid",
                        summary?["paid"] ?? "0",
                        Colors.green,
                        Icons.check_circle,
                      ),

                      summaryCard(
                        "Pending",
                        summary?["pending"] ?? "0",
                        Colors.orange,
                        Icons.pending,
                      ),

                      summaryCard(
                        "Overdue",
                        summary?["overdue"] ?? "0",
                        Colors.red,
                        Icons.warning,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  if (statistics != null) billPieChart(),

                  const SizedBox(height: 25),

                  const Text(
                    "Filter Bills",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children: [
                      filterChip("All"),

                      filterChip("Paid"),

                      filterChip("Pending"),

                      filterChip("Overdue"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: bills.length,

                    itemBuilder: (context, index) {
                      final bill = bills[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),

                        elevation: 4,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => BillDetailsScreen(bill: bill),
                              ),
                            );
                          },

                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.indigo,

                              child: Icon(
                                Icons.receipt_long,

                                color: Colors.white,
                              ),
                            ),

                            title: Text(
                              bill["bill_id"],

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "Customer : ${bill["customer_account_no"]}",
                                ),

                                Text("Month : ${bill["billing_month"]}"),

                                Text("PKR ${bill["amount"]}"),
                              ],
                            ),

                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,

                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: bill["bill_status"] == "Paid"
                                    ? Colors.green
                                    : bill["bill_status"] == "Pending"
                                    ? Colors.orange
                                    : Colors.red,

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
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget filterChip(String status) {
    return ChoiceChip(
      label: Text(status),

      selected: selectedStatus == status,

      onSelected: (value) {
        setState(() {
          selectedStatus = status;
        });

        loadBills();
      },
    );
  }
}
