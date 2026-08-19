import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/action_card.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/section_title.dart';
import '../../widgets/transaction_tile.dart';
import '../bill/customer_bills_screen.dart';
import '../qr/qr_generator_screen.dart';
import '../qr/qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> customer;

  const HomeScreen({super.key, required this.customer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;

  @override
  void initState() {
    super.initState();
    loadBalance();
  }

  Future<void> loadBalance() async {
    try {
      final data = await ApiService.getBalance(
        widget.customer["account_no"].toString(),
      );

      setState(() {
        balance = double.tryParse(data["running_balance"].toString()) ?? 0;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Bill Express"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadBalance,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Good Morning 👋",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 5),

              Text(
                widget.customer["first_name"] ?? "",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Account No: ${widget.customer["account_no"]}",
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 25),

              BalanceCard(
                balance: balance,
                accountNo: widget.customer["account_no"].toString(),
              ),

              const SizedBox(height: 30),

              const SectionTitle(title: "Quick Services"),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionCard(
                    icon: Icons.qr_code_scanner,
                    title: "Scan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QrScannerScreen(),
                        ),
                      ).then((_) => loadBalance());
                    },
                  ),

                  ActionCard(
                    icon: Icons.qr_code,
                    title: "Generate",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QrGeneratorScreen(),
                        ),
                      );
                    },
                  ),

                  ActionCard(
                    icon: Icons.receipt_long,
                    title: "Bills",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomerBillsScreen(),
                        ),
                      ).then((_) => loadBalance());
                    },
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const SectionTitle(title: "Recent Transactions"),

              const SizedBox(height: 18),

              FutureBuilder<List<dynamic>>(
                future: ApiService.getRecentTransactions(
                  widget.customer["account_no"].toString(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Text("Failed to load transactions");
                  }

                  final transactions = snapshot.data ?? [];

                  if (transactions.isEmpty) {
                    return const Text("No recent transactions");
                  }

                  return Column(
                    children: transactions.map((tx) {
                      final isCredit =
                          tx["to_account"].toString() ==
                          widget.customer["account_no"].toString();

                      return TransactionTile(
                        icon: isCredit
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        title: tx["transaction_type"],
                        subtitle: tx["created_at"].toString().substring(0, 10),
                        amount: "${isCredit ? "+" : "-"} PKR ${tx["amount"]}",
                        amountColor: isCredit ? Colors.green : Colors.red,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
