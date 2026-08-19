import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/api_service.dart';

class TransferScreen extends StatefulWidget {
  final String toAccount;
  final String amount;

  const TransferScreen({
    super.key,
    required this.toAccount,
    required this.amount,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final narration1Controller = TextEditingController();
  final narration2Controller = TextEditingController();
  final narration3Controller = TextEditingController();

  String transactionType = "Transfer";

  @override
  void dispose() {
    narration1Controller.dispose();
    narration2Controller.dispose();
    narration3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customer = SessionService.customer!;

    return Scaffold(
      appBar: AppBar(title: const Text("Send Money")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "From Account",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(customer["account_no"].toString()),
                subtitle: Text(
                  "${customer["first_name"]} ${customer["last_name"]}",
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "To Account",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.qr_code),
                title: Text(widget.toAccount),
                subtitle: const Text("Scanned from QR"),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(
                  widget.amount,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text("Transaction Type"),
                subtitle: Text("Transfer"),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: narration1Controller,

              decoration: const InputDecoration(
                labelText: "Narration Line 1",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: narration2Controller,

              decoration: const InputDecoration(
                labelText: "Narration Line 2",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: narration3Controller,

              decoration: const InputDecoration(
                labelText: "Narration Line 3",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  final fromAccount = customer["account_no"].toString();
                  if (fromAccount == widget.toAccount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "You cannot transfer money to your own account.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    final response = await ApiService.transferMoney(
                      fromAccount: fromAccount,
                      toAccount: widget.toAccount,
                      amount: double.parse(widget.amount),
                      narration1: narration1Controller.text,
                      narration2: narration2Controller.text,
                      narration3: narration3Controller.text,
                    );
                    

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Transfer Successful",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            "Your payment has been transferred successfully.\n\n"
                            "Amount: Rs. ${widget.amount}\n"
                            "Recipient: ${widget.toAccount}",
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(
                                  context,
                                ); // Back to previous screen
                              },
                              child: const Text("Done"),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text("Send Money", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
