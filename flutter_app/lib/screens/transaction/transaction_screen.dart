import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class TransactionScreen extends StatefulWidget {
  final Map<String, dynamic> customer;

  const TransactionScreen({
    super.key,
    required this.customer,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  List transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final data = await ApiService.getTransactionHistory(
        widget.customer["account_no"].toString(),
      );

      setState(() {
        transactions = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: const Text("Transaction History"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : transactions.isEmpty
              ? const Center(
                  child: Text(
                    "No Transactions Found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {

                    final tx = transactions[index];

                    bool isCredit =
                        tx["to_account"].toString() ==
                        widget.customer["account_no"].toString();

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),

                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor:
                              isCredit ? Colors.green : Colors.red,

                          child: Icon(
                            isCredit
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          tx["transaction_type"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(tx["narration_line1"] ?? ""),

                            Text(
                              tx["created_at"]
                                  .toString()
                                  .substring(0, 19),
                            ),

                            Text(
                              "Transaction ID : ${tx["transaction_id"]}",
                            ),
                          ],
                        ),

                        trailing: Text(
                          "${isCredit ? "+" : "-"} PKR ${tx["amount"]}",
                          style: TextStyle(
                            color: isCredit
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}